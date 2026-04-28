# Nightly Build — build_push_nightly.sh
![Lobot Nightly build](https://raw.githubusercontent.com/Queens-School-of-Computing/Lobot/main/assets/images/nightlybuildbanner.png)
## Overview

`build_push_nightly.sh` builds, tags, and pushes nightly Docker images for the
QSC JupyterHub cluster. It discovers all dated Dockerfiles in `.build/`,
extracts version strings automatically, pushes two tags per build (a floating
tag and a dated tag), prunes old dated tags from DockerHub, and emails a full
build report.

Designed to run on a dedicated build server with Docker and internet access.
The build server does not need `kubectl` or cluster access — it only pushes to
DockerHub. Cluster node pulls are handled separately by `image-pull.sh`.

---

## Prerequisites

- Docker (with `docker buildx` support for `--platform=linux/amd64`)
- Python 3 (used for DockerHub tag pruning and email notifications)
- Internet access to DockerHub (`registry-1.docker.io`)
- `DOCKERHUB_PASSWORD` set in the environment (see [Credentials](#credentials))

---

## Configuration

All tunable settings are at the top of the script:

```bash
REPO="queensschoolofcomputingdocker/gpu-jupyter-latest"
DOCKERHUB_USERNAME="queensschoolofcomputingdocker"
KEEP_NIGHTLY_COUNT=2   # dated history tags to keep per version (floating tag is additional)
PUSH_RETRIES=3         # number of push attempts before giving up
PUSH_RETRY_DELAY=30    # seconds to wait between push retries
```

| Variable | Description |
|----------|-------------|
| `REPO` | DockerHub repository path |
| `DOCKERHUB_USERNAME` | DockerHub account name (used for API authentication) |
| `KEEP_NIGHTLY_COUNT` | Number of dated history tags to keep per Dockerfile version. The floating tag is never pruned and is additional to this count. Changing to `7` retains a full week. |
| `PUSH_RETRIES` | How many times to retry a failed push before marking it as failed |
| `PUSH_RETRY_DELAY` | Seconds between push retry attempts |

### Credentials

`DOCKERHUB_PASSWORD` must be set in the environment before running. Never
hardcode it in the script:

```bash
export DOCKERHUB_PASSWORD=your_token_here
./build_push_nightly.sh
```

A DockerHub **access token** (not account password) is recommended. Create one
at hub.docker.com → Account Settings → Security → Access Tokens. The token
needs Read/Write/Delete scope on the repository.

---

## Dockerfile Discovery

The script scans `.build/` for files matching `Dockerfile.[0-9]{8}`:

```
.build/
  Dockerfile.20260313   → CUDA 13.0.2, TF 2.20.0, Ubuntu 24.04
  Dockerfile.20260424   → CUDA 13.2.1, TF 2.20.0, Ubuntu 24.04
```

Version strings are extracted automatically by grepping the active (non-commented)
lines of each Dockerfile:

| Version | Source |
|---------|--------|
| `CUDA` | First active `FROM nvidia/cuda:X.Y.Z` line |
| `Ubuntu` | First active `ubuntu24.04` (or similar) reference |
| `TensorFlow` | First active `tensorflow==X.Y.Z` in a pip install |

If any version cannot be extracted the Dockerfile is skipped with an error.

---

## Tag Strategy

Each build produces **two tags**:

| Tag | Format | Purpose |
|-----|--------|---------|
| Floating | `...-{DATE}-nightly` | Stable tag HTML pages link to. Updated each night to point to the latest build. |
| Dated | `...-{DATE}-nightly-{BUILD_DATE}` | History/rollback tag. Identifies exactly which night's build it is. |

Example for a build on 2026-04-28 from `Dockerfile.20260313`:

```
queensschoolofcomputingdocker/gpu-jupyter-latest:13.0.2cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260313-nightly
queensschoolofcomputingdocker/gpu-jupyter-latest:13.0.2cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260313-nightly-20260428
```

The floating tag is always what JupyterHub HTML pages reference — no HTML edits
are needed after each nightly build. The dated tag provides a rollback target
if a build introduces a regression.

---

## DockerHub Tag Pruning

After each successful push, the script calls DockerHub's REST API to prune old
dated tags for that Dockerfile version:

1. Authenticates with DockerHub (JWT via `/v2/users/login`)
2. Lists all tags for the repository
3. Filters to dated tags matching `...-{DOCKERFILE_DATE}-nightly-YYYYMMDD`
   (floating tags are never touched)
4. Sorts by build date, newest first
5. Deletes any dated tags beyond `KEEP_NIGHTLY_COUNT`

After a week of nightly builds with `KEEP_NIGHTLY_COUNT=2`, DockerHub holds:

```
...-20260313-nightly              ← floating, always present
...-20260313-nightly-20260428     ← yesterday
...-20260313-nightly-20260427     ← day before
```

Pruning is skipped (with a warning) if `DOCKERHUB_PASSWORD` is not set.

---

## Push Retry

Each `docker push` is wrapped in a retry loop. On a network timeout or proxy
error, the script waits `PUSH_RETRY_DELAY` seconds and tries again, up to
`PUSH_RETRIES` times. Each attempt is logged:

```
⚠️  Push attempt 1/3 failed for ...:...-nightly — retrying in 30s...
```

If all retries fail, the tag is marked as failed and the email reports failure.

---

## Usage

```bash
./build_push_nightly.sh [--dry-run] [--noemail]
```

| Flag | Description |
|------|-------------|
| `--dry-run` | Print what would be built and pushed; no Docker or DockerHub operations |
| `--noemail` | Skip the email notification |

### Dry-run

```bash
export DOCKERHUB_PASSWORD=...
./build_push_nightly.sh --dry-run
```

Logs what each Dockerfile would produce without touching Docker or DockerHub:

```
[dry-run] docker build --platform=linux/amd64 -f .build/Dockerfile.20260313 -t ...nightly .build/
[dry-run] docker tag ...nightly ...nightly-20260428
[dry-run] docker push ...nightly
[dry-run] docker push ...nightly-20260428
[dry-run] prune dated tags: keep 2 for *-20260313-nightly-*
```

---

## Email Notifications

Configure the SMTP block at the top of the script:

```bash
SMTP_SERVER="innovate.cs.queensu.ca"
SMTP_PORT=25
SMTP_USE_TLS=false
SMTP_USERNAME=""
SMTP_PASSWORD=""
FROM_EMAIL="lobot@cs.queensu.ca"
TO_EMAIL="aaron.visser@queensu.ca,whb1@queensu.ca"
```

| Variable | Description |
|----------|-------------|
| `EMAIL_ENABLED` | Set to `false` to disable all notifications |
| `SMTP_SERVER` | Hostname of the SMTP relay |
| `SMTP_PORT` | SMTP port (`25` = plain, `587` = submission+TLS) |
| `SMTP_USE_TLS` | Set to `true` to enable STARTTLS |
| `SMTP_USERNAME` / `SMTP_PASSWORD` | Leave empty for unauthenticated relay |
| `FROM_EMAIL` | Sender address |
| `TO_EMAIL` | Recipient(s), comma-separated |

Email is sent via Python 3 `smtplib`. The body is a dark-themed HTML page with a
colour-coded status banner (green for success, red for failure), a list of all
pushed tags, and the full build log.

Subject line format:
- `✅ Nightly build complete | YYYY-MM-DD | N image(s)`
- `❌ Nightly build FAILED | YYYY-MM-DD`

Pass `--noemail` to suppress the notification, useful for manual test runs or
dry-runs where an email is not needed.

---

## Log File

A temporary log file is written to `/tmp/build_push_nightly_$$.log` during the
run and included as the email body. It is deleted after the email is sent. If
the script is interrupted before sending, the log remains at that path.

---

## Typical Workflow

### Manual run

```bash
export DOCKERHUB_PASSWORD=<access-token>

# Dry-run first to confirm tag names and version extraction
./build_push_nightly.sh --dry-run --noemail

# Full build and push
./build_push_nightly.sh
```

### Automated (cron)

Add to crontab on the build server. Run at 02:00 nightly; credential is stored
in the crontab environment:

```
0 2 * * * DOCKERHUB_PASSWORD=<token> /path/to/gpu-jupyter-latest/build_push_nightly.sh
```

Or use a credentials file sourced before running:

```
0 2 * * * . /etc/lobot/dockerhub-creds && /path/to/gpu-jupyter-latest/build_push_nightly.sh
```

### After a nightly build: updating cluster nodes

After the build server pushes a new nightly, pull the new tags onto the target
nodes and clean up old ones. Combine all tags from all Dockerfile versions into
a single command and use `-e` to exclude every node that should *not* receive
the update. Use lobot-tui actions `[1]` and `[2]` to build the commands
interactively — the resulting command is logged and can be copied for future
runs.

```bash
# Pull — all tags for both versions; exclude all nodes except debwewin and duotronic
./image-pull.sh \
  -i queensschoolofcomputingdocker/gpu-jupyter-latest:13.2.1cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260424 \
  -i queensschoolofcomputingdocker/gpu-jupyter-latest:13.2.1cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260424-nightly \
  -i queensschoolofcomputingdocker/gpu-jupyter-latest:13.0.2cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260313 \
  -i queensschoolofcomputingdocker/gpu-jupyter-latest:13.0.2cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260313-nightly \
  -b 3 -t 1200 \
  -e bootstrap,floppy,fz1,fz2,giza,kickstart,lobot-a16-1,makemake,netfusion,newtek,pluto,titan \
  --yes

# Cleanup — keep same tags; remove all others from debwewin and duotronic
./image-cleanup.sh \
  -i queensschoolofcomputingdocker/gpu-jupyter-latest:13.2.1cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260424 \
  -i queensschoolofcomputingdocker/gpu-jupyter-latest:13.2.1cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260424-nightly \
  -i queensschoolofcomputingdocker/gpu-jupyter-latest:13.0.2cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260313 \
  -i queensschoolofcomputingdocker/gpu-jupyter-latest:13.0.2cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260313-nightly \
  -e bootstrap,floppy,fz1,fz2,giza,kickstart,lobot-a16-1,makemake,netfusion,newtek,pluto,titan \
  --yes
```

See [IMAGE-MANAGEMENT.md](IMAGE-MANAGEMENT.md) for full pull and cleanup documentation.

---

## Adding a New Dockerfile Version

1. Create `.build/Dockerfile.YYYYMMDD` with the new date (e.g. `Dockerfile.20260601`)
2. Ensure the file has an active (non-commented) `FROM nvidia/cuda:X.Y.Z-...` line,
   a `tensorflow==X.Y.Z` reference, and an `ubuntu24.04` (or similar) reference
3. Run `./build_push_nightly.sh --dry-run` to confirm version extraction
4. The build script picks it up automatically on the next run — no code changes needed

---

## Caveats

### `CACHE_BUST` and layer caching

Each Dockerfile uses `ARG CACHE_BUST=1` to control which layers rebuild nightly.
Layers before `ARG CACHE_BUST=1` are cached (they only rebuild when the
Dockerfile content above that line changes). Layers after it rebuild every run.

The nightly-rebuilt layers are: Chrome + ChromeDriver, VS Code, code-server,
Ollama, Claude Code, and uv. Everything else (MATLAB, PyTorch, xfce4, etc.) is
cached from the first build.

Pass `--no-cache` to Docker to force a full rebuild:

```bash
# Not done by the script — run manually if needed
docker build --no-cache --platform=linux/amd64 \
  -f .build/Dockerfile.20260313 \
  -t queensschoolofcomputingdocker/gpu-jupyter-latest:... \
  .build/
```

### Build server proxy

If the build server routes outbound traffic through a proxy, Docker may hit
`i/o timeout` errors on push. The `PUSH_RETRIES` and `PUSH_RETRY_DELAY`
settings handle transient timeouts automatically. If pushes fail consistently,
check `HTTP_PROXY` / `HTTPS_PROXY` in the Docker daemon environment.

### Platform mismatch

All builds use `--platform=linux/amd64` explicitly. If the build server is ARM
(e.g. Apple Silicon), ensure `docker buildx` with `linux/amd64` emulation is
available via QEMU. Builds will be slow under emulation — use a native x86_64
machine for production nightly builds.

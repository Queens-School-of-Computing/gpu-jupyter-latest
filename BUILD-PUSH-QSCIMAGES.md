# QSC Image Build — build_push_qscimages.sh
![Lobot Nightly build](https://raw.githubusercontent.com/Queens-School-of-Computing/Lobot/main/assets/images/nightlybuildbanner.png)
## Overview

`build_push_qscimages.sh` builds, tags, and pushes Docker images for the QSC
JupyterHub cluster. It handles two distinct build types per Dockerfile version:

- **Baseline build** — built once per Dockerfile version. Produces a stable,
  fully-cached image without forced layer refreshes. Skipped automatically if
  the baseline tag already exists locally.
- **Nightly build** — runs on a recurring schedule. Before building, the
  script resolves the latest upstream version of every frequently-updated
  component (Chrome, VS Code, Claude Code, etc.) and compares them against
  [component-versions.json](component-versions.json). If nothing changed —
  and the Dockerfiles themselves are unmodified — the nightly is skipped
  entirely. When something did change, only the layers from the first changed
  component downward are rebuilt (see
  [Component Version Tracking](#component-version-tracking)).

The script discovers all dated Dockerfiles in `.build/`, extracts version
strings automatically, pushes tags to DockerHub (and optionally a local
registry), prunes old dated nightly tags on DockerHub and locally, and emails
a full build report including per-step timing.

Designed to run on a dedicated build server with Docker and internet access.
The build server does not need `kubectl` or cluster access — it only pushes to
DockerHub. Cluster node pulls are handled separately by `image-pull.sh`.

---

## Prerequisites

- Docker Engine (with `docker buildx` support for `--platform=linux/amd64`)
- Python 3 (used for version resolution, DockerHub tag pruning, and email notifications)
- `tmux` (recommended — keeps the build alive if SSH disconnects)
- Internet access to DockerHub (`registry-1.docker.io`) and the component
  version endpoints (GitHub API, PyPI, npm registry, Google/Microsoft update APIs)
- `DOCKERHUB_PASSWORD` set in the environment (see [Credentials](#credentials))
- Git push credentials on the build server (only for the optional
  `component-versions.json` auto-commit — see
  [Component Version Tracking](#component-version-tracking))

---

## Build Server Setup (Ubuntu 26.04)

The following steps configure a fresh Ubuntu 26.04 x86_64 host. Run all
commands as `root`.

### 1. Install Docker Engine

```bash
apt update
apt install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  > /etc/apt/sources.list.d/docker.list

apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin
```

### 2. Verify Docker

```bash
docker run --rm hello-world
```

### 3. Install tmux

```bash
apt install -y tmux
```

### 4. Clone the repository

```bash
mkdir -p /root/GitHub
cd /root/GitHub
git clone https://github.com/Queens-School-of-Computing/gpu-jupyter-latest.git
cd gpu-jupyter-latest
```

### 5. Log in to DockerHub

```bash
docker login -u queensschoolofcomputingdocker
# enter your PAT when prompted
```

### 6. Set credentials

Use a DockerHub Personal Access Token (PAT). PATs contain only alphanumeric
characters and underscores — no shell quoting issues:

```bash
export DOCKERHUB_PASSWORD='dckr_pat_your_token_here'
```

Persist across sessions by adding to `/root/.bashrc`:

```bash
echo "export DOCKERHUB_PASSWORD='dckr_pat_your_token_here'" >> /root/.bashrc
```

### 7. Verify disk space

Each image is 30+ GB. With build cache, allow **200+ GB** free:

```bash
df -h /
```

### 8. First run (in tmux)

```bash
tmux new -s build
cd /root/GitHub/gpu-jupyter-latest

# Dry-run first to confirm tag names and version extraction
./build_push_qscimages.sh --dry-run --noemail

# Full build: builds baseline (if missing) then nightly
./build_push_qscimages.sh
```

Detach with `Ctrl+B, D`. Reattach later with:

```bash
tmux attach -t build
```

---

## Configuration

All tunable settings are at the top of the script:

```bash
REPO="queensschoolofcomputingdocker/gpu-jupyter-latest"
DOCKERHUB_USERNAME="queensschoolofcomputingdocker"
KEEP_NIGHTLY_COUNT=3   # dated history tags to keep per version (floating tag is additional)
PUSH_RETRIES=3         # number of push attempts before giving up
PUSH_RETRY_DELAY=30    # seconds to wait between push retries

# Component version tracking
VERSIONS_FILE="component-versions.json"
VERSIONS_AUTOCOMMIT=true   # git commit+push the updated manifest after a successful run

# Local registry (optional) — leave empty to skip
LOCAL_REGISTRY=""
LOCAL_REGISTRY_USERNAME="admin"
```

| Variable | Description |
|----------|-------------|
| `REPO` | DockerHub repository path |
| `DOCKERHUB_USERNAME` | DockerHub account name (used for API authentication) |
| `KEEP_NIGHTLY_COUNT` | Number of dated history tags to keep per Dockerfile version. The floating tag is never pruned and is additional to this count. Changing to `7` retains a full week. |
| `PUSH_RETRIES` | How many times to retry a failed push before marking it as failed |
| `PUSH_RETRY_DELAY` | Seconds between push retry attempts |
| `VERSIONS_FILE` | Manifest recording the component versions and Dockerfile hashes of the last successful build |
| `VERSIONS_AUTOCOMMIT` | Set to `false` to stop the script committing/pushing the manifest to GitHub after a successful run |
| `LOCAL_REGISTRY` | Optional local registry (`host:port`). Leave empty to skip local pushes. |
| `LOCAL_REGISTRY_USERNAME` | Username for the local registry |

### Local Registry

To push to a local Docker registry in addition to DockerHub, set `LOCAL_REGISTRY`
in the script and export `LOCAL_REGISTRY_PASSWORD` before running:

```bash
LOCAL_REGISTRY="distribution.cs.queensu.ca:5000"
LOCAL_REGISTRY_USERNAME="admin"
```

```bash
export LOCAL_REGISTRY_PASSWORD='your_registry_password'
./build_push_qscimages.sh
```

Leave `LOCAL_REGISTRY=""` (the default) to disable local pushes entirely.

### Credentials

`DOCKERHUB_PASSWORD` must be set in the environment before running. Never
hardcode it in the script:

```bash
export DOCKERHUB_PASSWORD='dckr_pat_your_token_here'
./build_push_qscimages.sh
```

A DockerHub **Personal Access Token (PAT)** is strongly recommended over your
account password. Create one at hub.docker.com → Account Settings → Security →
Access Tokens. The token needs Read/Write/Delete scope on the repository.

PATs have the format `dckr_pat_xxxx` and contain only alphanumeric characters
and underscores, so they never need special shell quoting.

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

Each Dockerfile version produces **three tags**:

| Tag | Format | Purpose |
|-----|--------|---------|
| Baseline | `...-{DATE}` | One-time stable build. Never rebuilt unless `--force-baseline`. |
| Floating | `...-{DATE}-nightly` | Updated each night to the latest nightly build. HTML pages link to this tag. |
| Dated | `...-{DATE}-nightly-{BUILD_DATE}` | History/rollback tag. Identifies exactly which night's build it is. |

Example from `Dockerfile.20260313`, built on 2026-04-30:

```
queensschoolofcomputingdocker/gpu-jupyter-latest:13.0.2cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260313
queensschoolofcomputingdocker/gpu-jupyter-latest:13.0.2cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260313-nightly
queensschoolofcomputingdocker/gpu-jupyter-latest:13.0.2cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260313-nightly-20260430
```

The baseline tag is the stable reference pulled to cluster nodes for initial
setup. The floating tag is what JupyterHub HTML pages reference — no HTML edits
are needed after each nightly build. The dated tag provides a rollback target
if a build introduces a regression.

---

## Component Version Tracking

The nightly build is **version-driven**: instead of force-refreshing layers on
a timer, the script resolves the latest upstream version of each
frequently-updated component and rebuilds only when something actually changed.

### How a nightly run decides what to do

1. `resolve_component_versions.py` queries each component's upstream API and
   prints the latest versions as JSON. If any endpoint fails, the run aborts
   with a failure email.
2. The result is compared against `component-versions.json` (the manifest from
   the last successful build). Each changed component is logged:
   `🔄 claude_code: 2.1.169 → 2.1.170`
3. Each Dockerfile is also hashed and compared against the manifest, so
   editing a Dockerfile triggers a rebuild even when no component changed.
4. **Nothing changed →** the nightly is skipped entirely: no build, no push,
   no new dated tag that night. The email reports "no changes".
   **Something changed →** the versions are passed to `docker build` as
   `--build-arg <COMPONENT>_VERSION=<version>` and only the layers from the
   first changed component downward are rebuilt.
5. After every tag pushed successfully, the manifest is rewritten with the new
   versions, the nightly date code, and the current Dockerfile hashes — and
   committed/pushed to GitHub (`VERSIONS_AUTOCOMMIT=true`). A failed run keeps
   the old manifest so the next run retries.

### The manifest

```json
{
  "build_date": "20260610",
  "components": {
    "selenium": "4.44.0",
    "vscode": "1.124.0",
    "code_server": "4.123.0",
    "chrome": "149.0.7827.55",
    "chromedriver": "149.0.7827.55",
    "ollama": "0.30.7",
    "opencode": "1.17.1",
    "uv": "0.11.19",
    "claude_code": "2.1.170"
  },
  "dockerfiles": {
    "Dockerfile.20260313": "<sha256>",
    "Dockerfile.20260424": "<sha256>"
  }
}
```

`build_date` is the date code of the nightly these versions correspond to —
the same `YYYYMMDD` used in the `...-nightly-YYYYMMDD` dated tags. Because the
manifest is committed to GitHub on every change, its git history doubles as a
changelog of what each nightly actually shipped, and the raw file can be
fetched (e.g. by the JupyterHub spawn page's image selection) to display the
component versions inside the current nightly image.

### Version sources

| Component | Source |
|-----------|--------|
| `selenium` | PyPI (`pypi.org/pypi/selenium/json`) |
| `vscode` | VS Code update API (`update.code.visualstudio.com`) |
| `code_server` | GitHub releases (`coder/code-server`) |
| `chrome` / `chromedriver` | chrome-for-testing API — one lookup for both, so they can never mismatch |
| `ollama` | GitHub releases (`ollama/ollama`) |
| `opencode` | GitHub releases (`sst/opencode`) |
| `uv` | GitHub releases (`astral-sh/uv`) |
| `claude_code` | npm registry (`@anthropic-ai/claude-code`) |

Chrome and opencode only ship "latest" installers, so for those two the build
arg acts as a cache key: the layer rebuilds exactly when a new release
appears, and the "latest" it downloads is that release.

### Layer ordering

Docker layers are a chain — when one layer rebuilds, every layer below it
rebuilds too. The component layers are therefore ordered **least → most
frequently updated** in the Dockerfiles:

```
selenium → VS Code → code-server → Chrome → ChromeDriver → Ollama → opencode → uv → Claude Code
```

A Claude Code release (near-daily) rebuilds only the bottom of the stack; a
selenium release (rare) rebuilds everything below it. The manifest's git
history shows how often each component actually changes — use it to re-tune
this order over time.

### Manifest auto-commit

With `VERSIONS_AUTOCOMMIT=true`, a successful run commits and pushes the
updated manifest to GitHub. This requires push credentials on the build server
(e.g. a GitHub PAT via `git config credential.helper store`). If the push
fails, the script logs a warning and continues — the manifest is still updated
locally, so skip detection keeps working; commit it manually when convenient.

---

## DockerHub Tag Pruning

After each successful nightly push, the script calls DockerHub's REST API to
prune old dated tags for that Dockerfile version:

1. Authenticates with DockerHub (JWT via `/v2/users/login`)
2. Lists all tags for the repository
3. Filters to dated tags matching `...-{DOCKERFILE_DATE}-nightly-YYYYMMDD`
   (baseline and floating tags are never touched)
4. Sorts by build date, newest first
5. Deletes any dated tags beyond `KEEP_NIGHTLY_COUNT`

With `KEEP_NIGHTLY_COUNT=3`, DockerHub holds (dated tags only appear on nights
something actually changed — see
[Component Version Tracking](#component-version-tracking)):

```
...-20260313                      ← baseline, always present
...-20260313-nightly              ← floating, always present
...-20260313-nightly-20260610     ← most recent changed build
...-20260313-nightly-20260608     ← previous
...-20260313-nightly-20260605     ← previous
```

Pruning is skipped (with a warning) if `DOCKERHUB_PASSWORD` is not set.

### Local image pruning

After a successful push, the build server also removes **all** of its local
dated nightly images (`...-nightly-YYYYMMDD`) for that Dockerfile version —
only DockerHub keeps the rollback history. The baseline and floating images
stay local so layer caching keeps working.

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
./build_push_qscimages.sh [--dry-run] [--noemail] [--no-dockerhub] [--push-only] [--baseline-only] [--nightly-only] [--force] [--force-baseline]
```

| Flag | Description |
|------|-------------|
| `--dry-run` | Print what would be built and pushed; no Docker or DockerHub operations |
| `--noemail` | Skip the email notification |
| `--no-dockerhub` | Skip DockerHub push (useful when pushing to local registry only) |
| `--push-only` | Skip all builds; push whatever local images already exist |
| `--baseline-only` | Build and push baseline only; skip nightly |
| `--nightly-only` | Skip baseline check entirely; build and push nightly only |
| `--force` | Rebuild nightly even if nothing changed and/or today's dated tag already exists locally |
| `--force-baseline` | Rebuild baseline even if it already exists locally |

`--baseline-only` and `--nightly-only` are mutually exclusive.

### Dry-run

```bash
export DOCKERHUB_PASSWORD='dckr_pat_your_token_here'
./build_push_qscimages.sh --dry-run
```

Resolves component versions, reports what changed, and logs what each
Dockerfile would produce — without touching Docker or DockerHub:

```
--- Resolving component versions ---
🔄 claude_code: 2.1.169 → 2.1.170
[dry-run] docker build --platform=linux/amd64 --build-arg SELENIUM_VERSION=4.44.0 ... --build-arg CLAUDE_CODE_VERSION=2.1.170 -f .build/Dockerfile.20260313 -t ...nightly .build/
[dry-run] docker tag ...nightly ...nightly-20260610
[dry-run] docker push ...nightly
[dry-run] docker push ...nightly-20260610
[dry-run] prune dated tags: keep 3 for *-20260313-nightly-*
[dry-run] prune local dated images for *-20260313-nightly-*
```

When nothing changed, the dry-run shows the skip instead:

```
No component version changes since the last recorded build.
[dry-run] no component or Dockerfile changes — would skip nightly (use --force to rebuild): ...nightly
```

### Baseline Build

The baseline is built automatically on the first run for each Dockerfile
version. On subsequent runs it is skipped:

```
⏭️  Baseline already exists — skipping (use --force-baseline to rebuild): ...20260313
```

To build only the baseline (e.g. when adding a new Dockerfile version):

```bash
./build_push_qscimages.sh --baseline-only
```

To force a full baseline rebuild:

```bash
./build_push_qscimages.sh --baseline-only --force-baseline
```

### Nightly Skip

If today's dated nightly tag already exists locally the nightly build is
skipped and the script proceeds directly to the push phase. This handles the
case where a previous run built successfully but failed to push:

```
⏭️  Today's nightly already exists — skipping (use --force to rebuild): ...-nightly-20260430
```

Use `--force` to rebuild regardless:

```bash
./build_push_qscimages.sh --force
```

### Timing

The script logs elapsed time for each phase:

```
⏱  Baseline build time: 3h 12m 44s
⏱  DockerHub push (baseline): 22m 10s
⏱  Nightly build time: 1h 42m 15s
⏱  DockerHub push (floating): 18m 4s
⏱  DockerHub push (dated):    17m 51s
⏱  Total time: 5h 52m 4s
```

Timing is included in the email body.

---

## Email Notifications

Configure the SMTP block at the top of the script:

```bash
SMTP_SERVER="innovate.cs.queensu.ca"
SMTP_PORT=25
SMTP_USE_TLS=false
SMTP_USERNAME=""
SMTP_PASSWORD=""
FROM_EMAIL="lobot+qscimagebuilder@cs.queensu.ca"
TO_EMAIL="aaron.visser+lobot@queensu.ca,whb1+lobot@queensu.ca"
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
- `✅ QSC image build complete | YYYY-MM-DD | N tag(s)`
- `✅ QSC image build | YYYY-MM-DD | no changes — nothing built`
- `❌ QSC image build FAILED | YYYY-MM-DD`

Pass `--noemail` to suppress the notification, useful for manual test runs or
dry-runs where an email is not needed.

---

## Log File

A temporary log file is written to `/tmp/build_push_qscimages_$$.log` during
the run and included as the email body. It is deleted at the end of every
completed run (even with `--noemail`). If the script is interrupted mid-run,
the log remains at that path.

---

## Typical Workflow

### Adding a new Dockerfile version (one-time)

```bash
export DOCKERHUB_PASSWORD='dckr_pat_your_token_here'

# Dry-run to confirm version extraction and tag names
./build_push_qscimages.sh --baseline-only --dry-run --noemail

# Build and push the baseline (run inside tmux — takes 3+ hours first time)
./build_push_qscimages.sh --baseline-only
```

### Manual nightly run

```bash
export DOCKERHUB_PASSWORD='dckr_pat_your_token_here'

# Dry-run first
./build_push_qscimages.sh --nightly-only --dry-run --noemail

# Full nightly build and push (run inside tmux)
./build_push_qscimages.sh --nightly-only
```

### Automated (cron)

Add to crontab on the build server. Run at 02:00 nightly. Use `--nightly-only`
so the cron job never accidentally triggers a baseline rebuild:

```
0 2 * * * . /etc/lobot/dockerhub-creds && /root/GitHub/gpu-jupyter-latest/build_push_qscimages.sh --nightly-only
```

Where `/etc/lobot/dockerhub-creds` contains:

```bash
export DOCKERHUB_PASSWORD='dckr_pat_your_token_here'
```

For the `component-versions.json` auto-commit to reach GitHub, the build
server's clone also needs push credentials (e.g. a GitHub PAT stored via
`git config credential.helper store`). Without them the script logs a warning
and continues — skip detection still works from the local manifest.

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
3. Run `./build_push_qscimages.sh --baseline-only --dry-run` to confirm version extraction
4. Run `./build_push_qscimages.sh --baseline-only` to build and push the baseline
5. The nightly cron will pick up the new Dockerfile automatically on its next run

---

## Caveats

### Per-component layer caching

There is no `CACHE_BUST` line anymore. Each frequently-updated component
declares an `ARG <COMPONENT>_VERSION` immediately before its layer; the build
script passes the resolved versions as `--build-arg`s, so a layer's cache is
invalidated exactly when its component's version changes. Everything below a
changed layer rebuilds too (Docker layers are a chain), which is why the
components are ordered least → most frequently updated.

The version-managed layers are: selenium (+PyVirtualDisplay), VS Code,
code-server (+ms-python extension), Chrome, ChromeDriver, Ollama, opencode,
uv, and Claude Code. Everything else (MATLAB, PyTorch, xfce4, etc.) is cached
from the baseline and only rebuilds when the Dockerfile content above changes.

The ARG defaults in the Dockerfiles are a snapshot so a manual no-arg
`docker build` still works; the build script always overrides them.

To force a completely fresh build of everything:

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
machine for production builds.

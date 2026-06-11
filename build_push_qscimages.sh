#!/usr/bin/env bash
set -euo pipefail
cd "$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

REPO="queensschoolofcomputingdocker/gpu-jupyter-latest"
DOCKERHUB_USERNAME="queensschoolofcomputingdocker"
# DOCKERHUB_PASSWORD must be set in the environment (export DOCKERHUB_PASSWORD=...)
KEEP_NIGHTLY_COUNT=3   # dated history tags to keep per version (floating tag is additional)
PUSH_RETRIES=3         # number of push attempts before giving up
PUSH_RETRY_DELAY=30    # seconds to wait between push retries

# Component version tracking. The manifest records the component versions and
# Dockerfile hashes of the last successful build; when nothing changed, the
# nightly build is skipped entirely.
VERSIONS_FILE="component-versions.json"
VERSIONS_AUTOCOMMIT=true   # git commit+push the updated manifest after a successful run

# Local registry (optional). Set to host:port to push there after DockerHub.
# Leave empty to skip. Example: LOCAL_REGISTRY="distribution.cs.queensu.ca:5000"
LOCAL_REGISTRY=""
LOCAL_REGISTRY_USERNAME="admin"
# LOCAL_REGISTRY_PASSWORD must be set in the environment (export LOCAL_REGISTRY_PASSWORD=...)
LOCAL_REGISTRY_PASSWORD="${LOCAL_REGISTRY_PASSWORD:-}"

DRY_RUN=false
EMAIL_ENABLED=true
PUSH_DOCKERHUB=true
PUSH_ONLY=false
FORCE_BUILD=false
FORCE_BASELINE=false
BASELINE_ONLY=false
NIGHTLY_ONLY=false
FULL_BUILD=false

SMTP_SERVER="innovate.cs.queensu.ca"
SMTP_PORT=25
SMTP_USE_TLS=false
SMTP_USERNAME=""
SMTP_PASSWORD=""
FROM_EMAIL="lobot+qscimagebuilder@cs.queensu.ca"
TO_EMAIL="aaron.visser+lobot@queensu.ca,whb1+lobot@queensu.ca"

LOG_FILE="/tmp/build_push_qscimages_$$.log"
EVENTS_FILE="/tmp/build_push_qscimages_events_$$.log"
BUILD_DATE=$(date '+%Y%m%d')
FAILED_LOG="/tmp/build_push_qscimages_${BUILD_DATE}_failed.log"   # full log preserved here when a run fails

for arg in "$@"; do
    case $arg in
        --dry-run)        DRY_RUN=true ;;
        --noemail)        EMAIL_ENABLED=false ;;
        --no-dockerhub)   PUSH_DOCKERHUB=false ;;
        --push-only)      PUSH_ONLY=true ;;
        --force)          FORCE_BUILD=true ;;
        --full)           FULL_BUILD=true ;;
        --force-baseline) FORCE_BASELINE=true ;;
        --baseline-only)  BASELINE_ONLY=true ;;
        --nightly-only)   NIGHTLY_ONLY=true ;;
        *) echo "Unknown argument: $arg"; exit 1 ;;
    esac
done

if [ "$BASELINE_ONLY" = "true" ] && [ "$NIGHTLY_ONLY" = "true" ]; then
    echo "Error: --baseline-only and --nightly-only are mutually exclusive"
    exit 1
fi

# --full: rebuilds every layer from scratch (--no-cache) and pushes to a
# distinct ...-nightly-full / ...-nightly-full-YYYYMMDD tag lineage, leaving
# the incremental -nightly tags untouched. Recorded as "full-nightly".
NIGHTLY_BUILD_OPTS=()
NIGHTLY_TYPE="nightly"
NIGHTLY_TAG_SUFFIX="nightly"
if [ "$FULL_BUILD" = "true" ]; then
    NIGHTLY_BUILD_OPTS=(--no-cache)
    NIGHTLY_TYPE="full-nightly"
    NIGHTLY_TAG_SUFFIX="nightly-full"
fi

# ── Logging ────────────────────────────────────────────────────────────────────

log() {
    echo "$*" | tee -a "$LOG_FILE"
}

record_event() {
    # RECORD|<image_date>|<type>|<status>|<duration_secs>|<tag>|<log-or-->
    # Consumed by update_image_metadata.py to build the changelog entry.
    echo "RECORD|$1|$2|$3|$4|$5|${6:--}" >> "$EVENTS_FILE"
}

push_with_retry() {
    local tag="$1"
    local attempt=1
    while [ $attempt -le $PUSH_RETRIES ]; do
        if docker push "$tag" 2>&1 | tee -a "$LOG_FILE"; then
            return 0
        fi
        if [ $attempt -lt $PUSH_RETRIES ]; then
            log "⚠️  Push attempt $attempt/$PUSH_RETRIES failed for $tag — retrying in ${PUSH_RETRY_DELAY}s..."
            sleep "$PUSH_RETRY_DELAY"
        fi
        attempt=$((attempt + 1))
    done
    log "❌ Push failed after $PUSH_RETRIES attempts: $tag"
    return 1
}

format_duration() {
    local secs=$1
    local h=$((secs / 3600))
    local m=$(((secs % 3600) / 60))
    local s=$((secs % 60))
    if [ $h -gt 0 ]; then printf "%dh %dm %ds" $h $m $s
    elif [ $m -gt 0 ]; then printf "%dm %ds" $m $s
    else printf "%ds" $s
    fi
}

# ── DockerHub tag pruning ─────────────────────────────────────────────────────

prune_nightly_tags() {
    local DOCKERFILE_DATE="$1"   # e.g. 20260313 — used to scope which tags to prune
    local TAG_SUFFIX="${2:-nightly}"   # nightly or nightly-full

    if [ "$DRY_RUN" = "true" ]; then
        log "[dry-run] prune_nightly_tags: would keep $KEEP_NIGHTLY_COUNT dated tags for *-${DOCKERFILE_DATE}-${TAG_SUFFIX}-*"
        return 0
    fi

    local DOCKERHUB_PASSWORD="${DOCKERHUB_PASSWORD:-}"
    if [ -z "$DOCKERHUB_PASSWORD" ]; then
        log "⚠️  DOCKERHUB_PASSWORD not set — skipping tag pruning"
        return 0
    fi

    python3 <<PYEOF
import json, re, sys
try:
    from urllib.request import urlopen, Request
    from urllib.error import HTTPError
    from urllib.parse import urlencode
except ImportError:
    print("error: urllib not available")
    sys.exit(1)

namespace  = "${DOCKERHUB_USERNAME}"
repo       = "gpu-jupyter-latest"
password   = "${DOCKERHUB_PASSWORD}"
keep       = ${KEEP_NIGHTLY_COUNT}
df_date    = "${DOCKERFILE_DATE}"
tag_suffix = "${TAG_SUFFIX}"

# 1. Login → JWT token
try:
    payload = json.dumps({"username": namespace, "password": password}).encode()
    req = Request("https://hub.docker.com/v2/users/login",
                  data=payload, headers={"Content-Type": "application/json"})
    with urlopen(req) as r:
        token = json.loads(r.read())["token"]
except Exception as e:
    print(f"error: DockerHub login failed: {e}")
    sys.exit(1)

headers = {"Authorization": f"JWT {token}"}

# 2. List all tags (up to 100 — more than enough for nightly history)
try:
    url = f"https://hub.docker.com/v2/repositories/{namespace}/{repo}/tags/?page_size=100"
    req = Request(url, headers=headers)
    with urlopen(req) as r:
        all_tags = [t["name"] for t in json.loads(r.read()).get("results", [])]
except Exception as e:
    print(f"error: could not list tags: {e}")
    sys.exit(1)

# 3. Filter to dated tags for this Dockerfile version and tag suffix:
#    pattern: *-{df_date}-{tag_suffix}-YYYYMMDD
pattern = re.compile(rf".*-{re.escape(df_date)}-{re.escape(tag_suffix)}-(\d{{8}})$")
dated = [(m.group(1), name) for name in all_tags if (m := pattern.match(name))]
dated.sort(reverse=True)   # newest build date first

print(f"Found {len(dated)} dated {tag_suffix} tag(s) for {df_date}: {[t for _, t in dated]}")

# 4. Delete everything beyond KEEP_NIGHTLY_COUNT
to_delete = dated[keep:]
if not to_delete:
    print(f"Nothing to prune (keeping all {len(dated)}).")
else:
    for _, tag in to_delete:
        try:
            url = f"https://hub.docker.com/v2/repositories/{namespace}/{repo}/tags/{tag}/"
            req = Request(url, headers=headers, method="DELETE")
            with urlopen(req):
                pass
            print(f"🗑  Pruned: {tag}")
        except HTTPError as e:
            print(f"⚠️  Could not delete {tag}: {e}")
        except Exception as e:
            print(f"⚠️  Could not delete {tag}: {e}")
PYEOF

    if [ $? -eq 0 ]; then
        log " 🗑  Tag pruning complete for ${DOCKERFILE_DATE} (${TAG_SUFFIX})"
    else
        log " ⚠️  Tag pruning failed for ${DOCKERFILE_DATE} (${TAG_SUFFIX}) (non-fatal)"
    fi
}

# ── Local image pruning ───────────────────────────────────────────────────────

prune_local_nightly_images() {
    local DOCKERFILE_DATE="$1"
    local TAG_SUFFIX="${2:-nightly}"

    if [ "$DRY_RUN" = "true" ]; then
        log "[dry-run] prune_local_nightly_images: would remove local dated images for *-${DOCKERFILE_DATE}-${TAG_SUFFIX}-*"
        return 0
    fi

    local dated_images
    dated_images=$(docker images --format "{{.Repository}}:{{.Tag}}" \
        | grep -E "^${REPO}:.*-${DOCKERFILE_DATE}-${TAG_SUFFIX}-[0-9]{8}$" || true)

    if [ -z "$dated_images" ]; then
        log "No local dated ${TAG_SUFFIX} images to prune for ${DOCKERFILE_DATE}"
        return 0
    fi

    echo "$dated_images" | while read -r img; do
        if docker rmi "$img" 2>&1 | tee -a "$LOG_FILE"; then
            log "🗑  Removed local: $img"
        else
            log "⚠️  Could not remove local image (may be in use): $img"
        fi
    done
}

# ── Email ─────────────────────────────────────────────────────────────────────

send_email() {
    local SUBJECT="$1"
    local BODY_FILE="$2"

    if [ "$EMAIL_ENABLED" != "true" ]; then
        rm -f "$BODY_FILE"
        return 0
    fi

    python3 <<PYEOF
import smtplib, socket
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

smtp_server = "${SMTP_SERVER}"
smtp_port   = ${SMTP_PORT}
use_tls     = "${SMTP_USE_TLS}" in ("true", "True", "1")
username    = "${SMTP_USERNAME}"
password    = "${SMTP_PASSWORD}"
from_email  = "${FROM_EMAIL}"
to_emails   = [a.strip() for a in "${TO_EMAIL}".split(",")]

with open("${BODY_FILE}", "r") as f:
    body = f.read()

msg = MIMEMultipart("alternative")
msg["Subject"] = """${SUBJECT}"""
msg["From"]    = f"{socket.getfqdn()} <{from_email}>"
msg["To"]      = ", ".join(to_emails)
msg.attach(MIMEText(body, "html"))

try:
    with smtplib.SMTP(smtp_server, smtp_port) as server:
        if use_tls:
            server.starttls()
        if username and password:
            server.login(username, password)
        server.sendmail(from_email, to_emails, msg.as_string())
    print("ok")
except Exception as e:
    print(f"error: {e}")
    exit(1)
PYEOF

    if [ $? -eq 0 ]; then
        echo " 📧 Email sent to $TO_EMAIL"
    else
        echo " ⚠️  Email failed to send"
    fi

    rm -f "$BODY_FILE"
}

build_email_body() {
    local STATUS="$1"
    shift
    local TAGS=("$@")

    if [ "$STATUS" = "success" ]; then
        STATUS_COLOR="#2e7d32"
        STATUS_LABEL="✅ QSC Image Build Completed Successfully"
    else
        STATUS_COLOR="#c62828"
        STATUS_LABEL="❌ QSC Image Build Completed With Errors"
    fi

    TAGS_HTML=""
    for t in "${TAGS[@]}"; do
        TAGS_HTML="${TAGS_HTML}<li style='margin:4px 0;'>${t}</li>"
    done

    LOG_CONTENT=$(cat "$LOG_FILE" | \
        grep -v "^[a-f0-9]\{12,64\}: " | \
        grep -v "^#[0-9]\+ " | \
        grep -v "^\s*---> " | \
        grep -v "^Step [0-9]\+/[0-9]\+\s*:" | \
        grep -v "^Removing intermediate container" | \
        sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' | \
        sed 's/✅/<span style="color:#2e7d32">✅/g' | \
        sed 's/❌/<span style="color:#c62828">❌/g' | \
        sed 's/⚠️/<span style="color:#f57f17">⚠️/g' | \
        sed 's/⏱/<span style="color:#9e9e9e">⏱/g' | \
        sed 's/⏭️/<span style="color:#6a1e99">⏭️/g' | \
        sed 's/🗑/<span style="color:#9e9e9e">🗑/g' | \
        awk '{print $0"</span><br>"}')

    cat <<BODYEOF
<html>
<body style="font-family: monospace; background-color: #1e1e1e; color: #d4d4d4; padding: 20px;">
  <div style="max-width: 900px; margin: 0 auto;">
    <div style="background-color: #2d2d2d; border-left: 5px solid ${STATUS_COLOR}; padding: 15px 20px; margin-bottom: 20px; border-radius: 4px;">
      <h2 style="margin: 0; color: ${STATUS_COLOR}; font-family: monospace;">${STATUS_LABEL}</h2>
      <p style="margin: 5px 0 0 0; color: #9e9e9e;">build_push_qscimages.sh &mdash; $(date)</p>
    </div>
    <div style="background-color: #2d2d2d; padding: 15px 20px; margin-bottom: 20px; border-radius: 4px;">
      <p style="margin: 0 0 8px 0; color: #9e9e9e;">Tags pushed:</p>
      <ul style="margin: 0; padding-left: 20px; color: #80cbc4;">
${TAGS_HTML}
      </ul>
    </div>
    <div style="background-color: #2d2d2d; padding: 20px; border-radius: 4px; line-height: 1.6;">
${LOG_CONTENT}
    </div>
    <div style="margin-top: 15px; color: #616161; font-size: 0.85em;">
      Sent by Lobot Cluster Management
    </div>
  </div>
</body>
</html>
BODYEOF
}

# ── Main ──────────────────────────────────────────────────────────────────────

> "$LOG_FILE"
> "$EVENTS_FILE"
SCRIPT_START=$(date +%s)

if [ "$DRY_RUN" = "true" ]; then
    log "=== DRY RUN — no builds or pushes will happen ==="
fi

if [ "$FULL_BUILD" = "true" ]; then
    log "=== FULL NIGHTLY — --no-cache; pushing to ...-nightly-full tags ==="
fi

# Log in to local registry if configured
if [ -n "$LOCAL_REGISTRY" ] && [ "$DRY_RUN" != "true" ]; then
    if [ -z "$LOCAL_REGISTRY_PASSWORD" ]; then
        log "⚠️  LOCAL_REGISTRY_PASSWORD not set — local registry push will likely fail"
    else
        log "--- Logging in to local registry: $LOCAL_REGISTRY ---"
        if echo "$LOCAL_REGISTRY_PASSWORD" | docker login "$LOCAL_REGISTRY" \
                --username "$LOCAL_REGISTRY_USERNAME" --password-stdin 2>&1 | tee -a "$LOG_FILE"; then
            log "✅ Local registry login successful"
        else
            log "⚠️  Local registry login failed — local pushes may fail"
        fi
    fi
fi

DOCKERFILES=$(find .build -maxdepth 1 -name 'Dockerfile.[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' | sort)

if [ -z "$DOCKERFILES" ]; then
    log "No dated Dockerfiles found in .build/"
    exit 1
fi

BUILT_TAGS=()
FAILED=false

# ── Component version resolution ──────────────────────────────────────────────
# Latest upstream versions are resolved once per run, compared against
# $VERSIONS_FILE, and passed to docker build as --build-arg. A Dockerfile's
# nightly is skipped when neither the component versions nor the Dockerfile
# itself changed since the last recorded build.

COMPONENT_BUILD_ARGS=()
NIGHTLY_VERDICTS=""
VERSIONS_CHANGED=false
NEW_VERSIONS=""

verdict_for() {
    echo "$NIGHTLY_VERDICTS" | awk -v f="$1" '$1 == f {print $2}'
}

if [ "$PUSH_ONLY" != "true" ]; then
    log "--- Resolving component versions ---"
    if ! NEW_VERSIONS=$(python3 resolve_component_versions.py 2>>"$LOG_FILE"); then
        log "❌ ERROR: component version resolution failed — see log for details"
        BODY_TMP=$(mktemp)
        build_email_body "failure" > "$BODY_TMP"
        send_email "❌ QSC image build FAILED | $(date '+%Y-%m-%d')" "$BODY_TMP"
        rm -f "$LOG_FILE" "$EVENTS_FILE"
        exit 1
    fi
    log "$NEW_VERSIONS"

    CHECK_OUTPUT=$(python3 - "$VERSIONS_FILE" "$NEW_VERSIONS" $DOCKERFILES <<'PYEOF'
import hashlib, json, os, sys

versions_file = sys.argv[1]
new = json.loads(sys.argv[2])
dockerfiles = sys.argv[3:]

ARG_NAMES = {
    "selenium": "SELENIUM_VERSION",
    "vscode": "VSCODE_VERSION",
    "code_server": "CODE_SERVER_VERSION",
    "chrome": "CHROME_VERSION",
    "chromedriver": "CHROMEDRIVER_VERSION",
    "ollama": "OLLAMA_VERSION",
    "opencode": "OPENCODE_VERSION",
    "uv": "UV_VERSION",
    "claude_code": "CLAUDE_CODE_VERSION",
}

old = {}
if os.path.exists(versions_file):
    with open(versions_file) as f:
        old = json.load(f)
old_components = old.get("components", {})
old_hashes = old.get("dockerfiles", {})

components_changed = False
for name, version in new.items():
    print(f"ARG {ARG_NAMES[name]}={version}")
    previous = old_components.get(name)
    if previous != version:
        components_changed = True
        print(f"DIFF {name} {previous or '(new)'} {version}")

for path in dockerfiles:
    base = os.path.basename(path)
    with open(path, "rb") as f:
        digest = hashlib.sha256(f.read()).hexdigest()
    changed = components_changed or old_hashes.get(base) != digest
    print(f"VERDICT {base} {'BUILD' if changed else 'SKIP'}")
PYEOF
    )

    while IFS=' ' read -r kind a b c; do
        case "$kind" in
            ARG)     COMPONENT_BUILD_ARGS+=(--build-arg "$a") ;;
            DIFF)    VERSIONS_CHANGED=true; log "🔄 ${a}: ${b} → ${c}" ;;
            VERDICT) NIGHTLY_VERDICTS="${NIGHTLY_VERDICTS}${a} ${b}"$'\n' ;;
        esac
    done <<< "$CHECK_OUTPUT"

    if [ "$VERSIONS_CHANGED" != "true" ]; then
        log "No component version changes since the last recorded build."
    fi
fi

# On full runs, the metadata step also records full_components — the versions
# the last fresh-everything rebuild shipped.
METADATA_FULL_ARGS=()
if [ "$FULL_BUILD" = "true" ] && [ -n "$NEW_VERSIONS" ]; then
    METADATA_FULL_ARGS=(--full-versions "$NEW_VERSIONS")
fi

for DOCKERFILE in $DOCKERFILES; do
    DATE=$(basename "$DOCKERFILE" | grep -oE '[0-9]{8}')
    CUDA=$(grep -v '^[[:space:]]*#' "$DOCKERFILE" | grep -oE 'nvidia/cuda:[0-9]+\.[0-9]+\.[0-9]+' | head -1 | cut -d: -f2)
    UBUNTU=$(grep -v '^[[:space:]]*#' "$DOCKERFILE" | grep -oE 'ubuntu[0-9]+\.[0-9]+' | head -1 | grep -oE '[0-9]+\.[0-9]+')
    TF=$(grep -v '^[[:space:]]*#' "$DOCKERFILE" | grep -oE 'tensorflow==[0-9]+\.[0-9]+\.[0-9]+' | head -1 | cut -d= -f3)

    if [ -z "$CUDA" ] || [ -z "$UBUNTU" ] || [ -z "$TF" ]; then
        log "❌ ERROR: Could not extract versions from $DOCKERFILE (CUDA=$CUDA UBUNTU=$UBUNTU TF=$TF)"
        FAILED=true
        continue
    fi

    BASELINE_SUFFIX="${CUDA}cudnn-${TF}tf-matlab-ollama-claude-qsc-u${UBUNTU}-${DATE}"
    BASELINE_TAG="${REPO}:${BASELINE_SUFFIX}"

    IMAGE_SUFFIX="${BASELINE_SUFFIX}-${NIGHTLY_TAG_SUFFIX}"
    FLOATING_TAG="${REPO}:${IMAGE_SUFFIX}"
    DATED_TAG="${FLOATING_TAG}-${BUILD_DATE}"

    LOCAL_BASELINE_TAG=""
    LOCAL_FLOATING_TAG=""
    LOCAL_DATED_TAG=""
    if [ -n "$LOCAL_REGISTRY" ]; then
        LOCAL_BASELINE_TAG="${LOCAL_REGISTRY}/gpu-jupyter-latest:${BASELINE_SUFFIX}"
        LOCAL_FLOATING_TAG="${LOCAL_REGISTRY}/gpu-jupyter-latest:${IMAGE_SUFFIX}"
        LOCAL_DATED_TAG="${LOCAL_FLOATING_TAG}-${BUILD_DATE}"
    fi

    log "=========================================="
    log " Dockerfile:    $DOCKERFILE"
    log " CUDA:          $CUDA"
    log " Ubuntu:        $UBUNTU"
    log " TensorFlow:    $TF"
    log " Baseline tag:  $BASELINE_TAG"
    log " Floating tag:  $FLOATING_TAG"
    log " Dated tag:     $DATED_TAG"
    if [ -n "$LOCAL_REGISTRY" ]; then
        log " Local base:    $LOCAL_BASELINE_TAG"
        log " Local:         $LOCAL_FLOATING_TAG"
        log " Local dated:   $LOCAL_DATED_TAG"
    fi
    log "=========================================="

    if [ "$DRY_RUN" = "true" ]; then

        # ── Baseline dry-run ──
        if [ "$NIGHTLY_ONLY" != "true" ]; then
            if [ "$PUSH_ONLY" = "true" ]; then
                log "[dry-run] skipping baseline build (--push-only) — would use existing: $BASELINE_TAG"
            elif docker image inspect "$BASELINE_TAG" > /dev/null 2>&1 && [ "$FORCE_BASELINE" != "true" ]; then
                log "[dry-run] baseline already exists — would skip (use --force-baseline to rebuild): $BASELINE_TAG"
            else
                log "[dry-run] docker build --platform=linux/amd64 ${COMPONENT_BUILD_ARGS[*]:-} -f $DOCKERFILE -t $BASELINE_TAG .build/"
            fi
            if [ "$PUSH_DOCKERHUB" = "true" ]; then
                log "[dry-run] docker push $BASELINE_TAG"
            fi
            if [ -n "$LOCAL_REGISTRY" ]; then
                log "[dry-run] docker push $LOCAL_BASELINE_TAG"
            fi
            BUILT_TAGS+=("$BASELINE_TAG")
            [ -n "$LOCAL_REGISTRY" ] && BUILT_TAGS+=("$LOCAL_BASELINE_TAG")
        fi

        # ── Nightly dry-run ──
        if [ "$BASELINE_ONLY" != "true" ]; then
            if [ "$(verdict_for "$(basename "$DOCKERFILE")")" = "SKIP" ] && [ "$FORCE_BUILD" != "true" ] && [ "$FULL_BUILD" != "true" ] && [ "$PUSH_ONLY" != "true" ]; then
                log "[dry-run] no component or Dockerfile changes — would skip nightly (use --force to rebuild): $FLOATING_TAG"
            else
                if [ "$PUSH_ONLY" = "true" ]; then
                    log "[dry-run] skipping nightly build (--push-only) — would use existing: $FLOATING_TAG"
                elif docker image inspect "$DATED_TAG" > /dev/null 2>&1 && [ "$FORCE_BUILD" != "true" ] && [ "$FULL_BUILD" != "true" ]; then
                    log "[dry-run] today's nightly already exists — would skip (use --force to rebuild): $DATED_TAG"
                else
                    log "[dry-run] docker build --platform=linux/amd64 ${NIGHTLY_BUILD_OPTS[*]:-} ${COMPONENT_BUILD_ARGS[*]:-} -f $DOCKERFILE -t $FLOATING_TAG .build/"
                fi
                log "[dry-run] docker tag $FLOATING_TAG $DATED_TAG"
                if [ "$PUSH_DOCKERHUB" = "true" ]; then
                    log "[dry-run] docker push $FLOATING_TAG"
                    log "[dry-run] docker push $DATED_TAG"
                    log "[dry-run] prune dated tags: keep $KEEP_NIGHTLY_COUNT for *-${DATE}-${NIGHTLY_TAG_SUFFIX}-*"
                    log "[dry-run] prune local dated images for *-${DATE}-${NIGHTLY_TAG_SUFFIX}-*"
                else
                    log "[dry-run] skipping DockerHub push (--no-dockerhub)"
                fi
                if [ -n "$LOCAL_REGISTRY" ]; then
                    log "[dry-run] docker push $LOCAL_FLOATING_TAG"
                    log "[dry-run] docker push $LOCAL_DATED_TAG"
                fi
                BUILT_TAGS+=("$FLOATING_TAG" "$DATED_TAG")
                [ -n "$LOCAL_REGISTRY" ] && BUILT_TAGS+=("$LOCAL_FLOATING_TAG" "$LOCAL_DATED_TAG")
            fi
        fi

    else

        # ── Baseline phase ────────────────────────────────────────────────────
        if [ "$NIGHTLY_ONLY" != "true" ]; then
            BASELINE_OK=false
            BASELINE_STATUS=skipped   # not rebuilt tonight — the normal case
            BASELINE_DURATION=0
            if [ "$PUSH_ONLY" = "true" ]; then
                if docker image inspect "$BASELINE_TAG" > /dev/null 2>&1; then
                    log "⏭️  Skipping baseline build (--push-only) — using existing: $BASELINE_TAG"
                    BASELINE_OK=true
                else
                    log "⚠️  Baseline image not found locally — skipping: $BASELINE_TAG"
                fi
            elif docker image inspect "$BASELINE_TAG" > /dev/null 2>&1 && [ "$FORCE_BASELINE" != "true" ]; then
                log "⏭️  Baseline already exists — skipping (use --force-baseline to rebuild): $BASELINE_TAG"
                BASELINE_OK=true
            else
                BUILD_START=$(date +%s)
                if docker build --platform=linux/amd64 "${COMPONENT_BUILD_ARGS[@]}" -f "$DOCKERFILE" -t "$BASELINE_TAG" .build/ 2>&1 | tee -a "$LOG_FILE"; then
                    BASELINE_DURATION=$(( $(date +%s) - BUILD_START ))
                    log "⏱  Baseline build time: $(format_duration "$BASELINE_DURATION")"
                    BASELINE_OK=true
                    BASELINE_STATUS=success
                else
                    BASELINE_DURATION=$(( $(date +%s) - BUILD_START ))
                    log "❌ Baseline build failed after $(format_duration "$BASELINE_DURATION"): $BASELINE_TAG"
                    BASELINE_STATUS=failed
                    FAILED=true
                fi
            fi

            if [ "$BASELINE_OK" = "true" ]; then
                if [ "$PUSH_DOCKERHUB" = "true" ]; then
                    PUSH_START=$(date +%s)
                    if push_with_retry "$BASELINE_TAG"; then
                        log "⏱  DockerHub push (baseline): $(format_duration $(( $(date +%s) - PUSH_START )))"
                        log "✅ Done: $BASELINE_TAG"
                        BUILT_TAGS+=("$BASELINE_TAG")
                    else
                        log "⏱  DockerHub push (baseline): $(format_duration $(( $(date +%s) - PUSH_START )))"
                        log "❌ Push failed: $BASELINE_TAG"
                        BASELINE_STATUS=failed
                        FAILED=true
                    fi
                else
                    log "⏭️  Skipping DockerHub push (--no-dockerhub)"
                fi

                if [ -n "$LOCAL_REGISTRY" ] && [ -n "$LOCAL_BASELINE_TAG" ]; then
                    docker tag "$BASELINE_TAG" "$LOCAL_BASELINE_TAG"
                    PUSH_START=$(date +%s)
                    if push_with_retry "$LOCAL_BASELINE_TAG"; then
                        log "⏱  Local push (baseline): $(format_duration $(( $(date +%s) - PUSH_START )))"
                        log "✅ Local: $LOCAL_BASELINE_TAG"
                        BUILT_TAGS+=("$LOCAL_BASELINE_TAG")
                    else
                        log "⏱  Local push (baseline): $(format_duration $(( $(date +%s) - PUSH_START )))"
                        log "⚠️  Local baseline push failed (non-fatal): $LOCAL_BASELINE_TAG"
                    fi
                fi
            fi

            [ "$BASELINE_STATUS" = "failed" ] && BASELINE_EVENT_LOG="$FAILED_LOG" || BASELINE_EVENT_LOG="-"
            record_event "$DATE" baseline "$BASELINE_STATUS" "$BASELINE_DURATION" "$BASELINE_TAG" "$BASELINE_EVENT_LOG"
        fi

        # ── Nightly phase ─────────────────────────────────────────────────────
        if [ "$BASELINE_ONLY" != "true" ]; then
            # Skip when neither component versions nor this Dockerfile changed
            if [ "$(verdict_for "$(basename "$DOCKERFILE")")" = "SKIP" ] && [ "$FORCE_BUILD" != "true" ] && [ "$FULL_BUILD" != "true" ] && [ "$PUSH_ONLY" != "true" ]; then
            log "⏭️  No component or Dockerfile changes since last build — skipping nightly (use --force to rebuild): $FLOATING_TAG"
            record_event "$DATE" nightly skipped 0 "$FLOATING_TAG"
            else
            BUILD_START=$(date +%s)
            BUILD_OK=false
            NIGHTLY_STATUS=failed
            NIGHTLY_DURATION=0
            if [ "$PUSH_ONLY" = "true" ]; then
                log "⏭️  Skipping nightly build (--push-only) — using existing: $FLOATING_TAG"
                if ! docker image inspect "$FLOATING_TAG" > /dev/null 2>&1; then
                    log "❌ Image not found locally: $FLOATING_TAG"
                    FAILED=true
                else
                    docker tag "$FLOATING_TAG" "$DATED_TAG"
                    BUILD_OK=true
                    NIGHTLY_STATUS=success
                fi
            elif docker image inspect "$DATED_TAG" > /dev/null 2>&1 && [ "$FORCE_BUILD" != "true" ] && [ "$FULL_BUILD" != "true" ]; then
                log "⏭️  Today's nightly already exists — skipping (use --force to rebuild): $DATED_TAG"
                BUILD_OK=true
                NIGHTLY_STATUS=success   # re-push of a build whose push failed earlier today
            elif docker build --platform=linux/amd64 ${NIGHTLY_BUILD_OPTS[@]+"${NIGHTLY_BUILD_OPTS[@]}"} "${COMPONENT_BUILD_ARGS[@]}" -f "$DOCKERFILE" -t "$FLOATING_TAG" .build/ 2>&1 | tee -a "$LOG_FILE"; then
                NIGHTLY_DURATION=$(( $(date +%s) - BUILD_START ))
                log "⏱  Nightly build time: $(format_duration "$NIGHTLY_DURATION")"
                docker tag "$FLOATING_TAG" "$DATED_TAG"
                BUILD_OK=true
                NIGHTLY_STATUS=success
            else
                NIGHTLY_DURATION=$(( $(date +%s) - BUILD_START ))
                log "❌ Nightly build failed after $(format_duration "$NIGHTLY_DURATION"): $FLOATING_TAG"
                FAILED=true
            fi

            if [ "$BUILD_OK" = "true" ]; then
                if [ "$PUSH_DOCKERHUB" = "true" ]; then
                    PUSH_OK=true
                    PUSH_START=$(date +%s); push_with_retry "$FLOATING_TAG" || PUSH_OK=false
                    log "⏱  DockerHub push (floating): $(format_duration $(( $(date +%s) - PUSH_START )))"
                    PUSH_START=$(date +%s); push_with_retry "$DATED_TAG"    || PUSH_OK=false
                    log "⏱  DockerHub push (dated):    $(format_duration $(( $(date +%s) - PUSH_START )))"

                    if [ "$PUSH_OK" = "true" ]; then
                        log "✅ Done: $FLOATING_TAG"
                        log "✅ Done: $DATED_TAG"
                        BUILT_TAGS+=("$FLOATING_TAG" "$DATED_TAG")
                        prune_nightly_tags "$DATE" "$NIGHTLY_TAG_SUFFIX" 2>&1 | tee -a "$LOG_FILE"
                        prune_local_nightly_images "$DATE" "$NIGHTLY_TAG_SUFFIX" 2>&1 | tee -a "$LOG_FILE"
                    else
                        log "❌ Push failed for $FLOATING_TAG / $DATED_TAG"
                        NIGHTLY_STATUS=failed
                        FAILED=true
                    fi
                else
                    log "⏭️  Skipping DockerHub push (--no-dockerhub)"
                fi

                if [ -n "$LOCAL_REGISTRY" ]; then
                    log "--- Pushing to local registry: $LOCAL_REGISTRY ---"
                    docker tag "$FLOATING_TAG" "$LOCAL_FLOATING_TAG"
                    docker tag "$FLOATING_TAG" "$LOCAL_DATED_TAG"
                    LOCAL_PUSH_OK=true
                    PUSH_START=$(date +%s); push_with_retry "$LOCAL_FLOATING_TAG" || LOCAL_PUSH_OK=false
                    log "⏱  Local push (floating): $(format_duration $(( $(date +%s) - PUSH_START )))"
                    PUSH_START=$(date +%s); push_with_retry "$LOCAL_DATED_TAG"    || LOCAL_PUSH_OK=false
                    log "⏱  Local push (dated):    $(format_duration $(( $(date +%s) - PUSH_START )))"
                    if [ "$LOCAL_PUSH_OK" = "true" ]; then
                        log "✅ Local: $LOCAL_FLOATING_TAG"
                        log "✅ Local: $LOCAL_DATED_TAG"
                        BUILT_TAGS+=("$LOCAL_FLOATING_TAG" "$LOCAL_DATED_TAG")
                    else
                        log "⚠️  Local registry push failed (non-fatal) for $LOCAL_FLOATING_TAG"
                    fi
                fi
            fi

            [ "$NIGHTLY_STATUS" = "failed" ] && NIGHTLY_EVENT_LOG="$FAILED_LOG" || NIGHTLY_EVENT_LOG="-"
            record_event "$DATE" "$NIGHTLY_TYPE" "$NIGHTLY_STATUS" "$NIGHTLY_DURATION" "$DATED_TAG" "$NIGHTLY_EVENT_LOG"
            fi   # end skip-verdict else
        fi

    fi

    log ""
done

if [ "$FAILED" = "true" ]; then
    log "=========================================="
    log "❌ One or more builds/pushes failed."
    log "⏱  Total time: $(format_duration $(( $(date +%s) - SCRIPT_START )))"
    log "=========================================="
    # Record the failed run in the changelog; --no-manifest keeps the old
    # manifest so the next run retries the same version changes.
    if [ "$DRY_RUN" != "true" ] && [ -n "$NEW_VERSIONS" ]; then
        if python3 update_image_metadata.py build --no-manifest \
                ${METADATA_FULL_ARGS[@]+"${METADATA_FULL_ARGS[@]}"} \
                --new-versions "$NEW_VERSIONS" --build-date "$BUILD_DATE" \
                --events-file "$EVENTS_FILE" --log-file "$LOG_FILE" \
                --dockerfiles $DOCKERFILES 2>&1 | tee -a "$LOG_FILE"; then
            if [ "$VERSIONS_AUTOCOMMIT" = "true" ]; then
                { git add changelog-data.json IMAGE-CHANGELOG.md \
                    && git -c user.name="QSC Image Builder" -c user.email="${FROM_EMAIL}" \
                        commit -m "chore: build changelog $(date '+%Y-%m-%d') (failed run)" \
                    && git push; } >> "$LOG_FILE" 2>&1 \
                    || log "⚠️  Could not commit/push changelog (non-fatal — commit manually)"
            fi
        else
            log "⚠️  Metadata update failed (non-fatal)"
        fi
    fi
    BODY_TMP=$(mktemp)
    build_email_body "failure" "${BUILT_TAGS[@]:-}" > "$BODY_TMP"
    send_email "❌ QSC image build FAILED | $(date '+%Y-%m-%d')" "$BODY_TMP"
    mv -f "$LOG_FILE" "$FAILED_LOG" 2>/dev/null || rm -f "$LOG_FILE"
    echo "Full log preserved at ${FAILED_LOG}"
    rm -f "$EVENTS_FILE"
    exit 1
else
    log "=========================================="
    log "✅ All builds complete."
    log "⏱  Total time: $(format_duration $(( $(date +%s) - SCRIPT_START )))"
    log "=========================================="

    # Record the run: manifest (component versions + Dockerfile hashes, so the
    # next run can skip when nothing changed) plus changelog entry. The manifest
    # only advances after a full nightly run delivered to DockerHub — baseline-only
    # and --no-dockerhub runs record the changelog entry but keep the old manifest
    # so skip detection still triggers the real build.
    if [ "$DRY_RUN" != "true" ] && [ "$PUSH_ONLY" != "true" ] \
        && [ -n "$NEW_VERSIONS" ] && [ ${#BUILT_TAGS[@]} -gt 0 ]; then
        METADATA_MANIFEST_FLAG=""
        if [ "$BASELINE_ONLY" = "true" ] || [ "$PUSH_DOCKERHUB" != "true" ]; then
            METADATA_MANIFEST_FLAG="--no-manifest"
        fi
        if python3 update_image_metadata.py build $METADATA_MANIFEST_FLAG \
                ${METADATA_FULL_ARGS[@]+"${METADATA_FULL_ARGS[@]}"} \
                --new-versions "$NEW_VERSIONS" --build-date "$BUILD_DATE" \
                --events-file "$EVENTS_FILE" --log-file "$LOG_FILE" \
                --dockerfiles $DOCKERFILES 2>&1 | tee -a "$LOG_FILE"; then
            if [ "$VERSIONS_AUTOCOMMIT" = "true" ]; then
                if { git add "$VERSIONS_FILE" changelog-data.json IMAGE-CHANGELOG.md \
                    && git -c user.name="QSC Image Builder" -c user.email="${FROM_EMAIL}" \
                        commit -m "chore: component versions $(date '+%Y-%m-%d')" \
                    && git push; } >> "$LOG_FILE" 2>&1; then
                    log "📤 Committed and pushed ${VERSIONS_FILE} + changelog"
                else
                    log "⚠️  Could not commit/push manifest/changelog (non-fatal — commit manually)"
                fi
            fi
        else
            log "⚠️  Metadata update failed (non-fatal) — ${VERSIONS_FILE} not rewritten; next run rebuilds"
        fi
    fi

    if [ ${#BUILT_TAGS[@]} -eq 0 ]; then
        SUBJECT="✅ QSC image build | $(date '+%Y-%m-%d') | no changes — nothing built"
    else
        SUBJECT="✅ QSC image build complete | $(date '+%Y-%m-%d') | ${#BUILT_TAGS[@]} tag(s)"
    fi
    BODY_TMP=$(mktemp)
    build_email_body "success" ${BUILT_TAGS[@]:+"${BUILT_TAGS[@]}"} > "$BODY_TMP"
    send_email "$SUBJECT" "$BODY_TMP"
    rm -f "$LOG_FILE" "$EVENTS_FILE"
fi

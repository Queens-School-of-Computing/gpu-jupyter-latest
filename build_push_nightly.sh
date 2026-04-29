#!/usr/bin/env bash
set -euo pipefail
cd "$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

REPO="queensschoolofcomputingdocker/gpu-jupyter-latest"
DOCKERHUB_USERNAME="queensschoolofcomputingdocker"
# DOCKERHUB_PASSWORD must be set in the environment (export DOCKERHUB_PASSWORD=...)
KEEP_NIGHTLY_COUNT=2   # dated history tags to keep per version (floating tag is additional)
PUSH_RETRIES=3         # number of push attempts before giving up
PUSH_RETRY_DELAY=30    # seconds to wait between push retries

# Local registry (optional). Set to host:port to push there after DockerHub.
# Leave empty to skip. Example: LOCAL_REGISTRY="130.15.1.150:5050"
#LOCAL_REGISTRY="130.15.1.150:5050"
LOCAL_REGISTRY=""
LOCAL_REGISTRY_USERNAME="admin"
# LOCAL_REGISTRY_PASSWORD must be set in the environment (export LOCAL_REGISTRY_PASSWORD=...)
LOCAL_REGISTRY_PASSWORD="${LOCAL_REGISTRY_PASSWORD:-}"

DRY_RUN=false
EMAIL_ENABLED=true
PUSH_DOCKERHUB=true
PUSH_ONLY=false

SMTP_SERVER="innovate.cs.queensu.ca"
SMTP_PORT=25
SMTP_USE_TLS=false
SMTP_USERNAME=""
SMTP_PASSWORD=""
FROM_EMAIL="lobot-nightlybuild@cs.queensu.ca"
TO_EMAIL="aaron.visser@queensu.ca"

LOG_FILE="/tmp/build_push_nightly_$$.log"
BUILD_DATE=$(date '+%Y%m%d')
CACHE_BUST=$(date '+%s')   # unique per run — always busts post-CACHE_BUST layers

for arg in "$@"; do
    case $arg in
        --dry-run) DRY_RUN=true ;;
        --noemail) EMAIL_ENABLED=false ;;
        --no-dockerhub) PUSH_DOCKERHUB=false ;;
        --push-only) PUSH_ONLY=true ;;
        *) echo "Unknown argument: $arg"; exit 1 ;;
    esac
done

# ── Logging ────────────────────────────────────────────────────────────────────

log() {
    echo "$*" | tee -a "$LOG_FILE"
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

# ── DockerHub tag pruning ─────────────────────────────────────────────────────

prune_nightly_tags() {
    local DOCKERFILE_DATE="$1"   # e.g. 20260313 — used to scope which tags to prune

    if [ "$DRY_RUN" = "true" ]; then
        log "[dry-run] prune_nightly_tags: would keep $KEEP_NIGHTLY_COUNT dated tags for *-${DOCKERFILE_DATE}-nightly-*"
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

namespace = "${DOCKERHUB_USERNAME}"
repo      = "gpu-jupyter-latest"
password  = "${DOCKERHUB_PASSWORD}"
keep      = ${KEEP_NIGHTLY_COUNT}
df_date   = "${DOCKERFILE_DATE}"

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

# 3. Filter to dated nightly tags for this Dockerfile version:
#    pattern: *-{df_date}-nightly-YYYYMMDD
pattern = re.compile(rf".*-{re.escape(df_date)}-nightly-(\d{{8}})$")
dated = [(m.group(1), name) for name in all_tags if (m := pattern.match(name))]
dated.sort(reverse=True)   # newest build date first

print(f"Found {len(dated)} dated nightly tag(s) for {df_date}: {[t for _, t in dated]}")

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
        log " 🗑  Tag pruning complete for ${DOCKERFILE_DATE}"
    else
        log " ⚠️  Tag pruning failed for ${DOCKERFILE_DATE} (non-fatal)"
    fi
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
        STATUS_LABEL="✅ Nightly Build Completed Successfully"
    else
        STATUS_COLOR="#c62828"
        STATUS_LABEL="❌ Nightly Build Completed With Errors"
    fi

    TAGS_HTML=""
    for t in "${TAGS[@]}"; do
        TAGS_HTML="${TAGS_HTML}<li style='margin:4px 0;'>${t}</li>"
    done

    LOG_CONTENT=$(cat "$LOG_FILE" | \
        sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' | \
        sed 's/✅/<span style="color:#2e7d32">✅/g' | \
        sed 's/❌/<span style="color:#c62828">❌/g' | \
        sed 's/⚠️/<span style="color:#f57f17">⚠️/g' | \
        sed 's/🗑/<span style="color:#9e9e9e">🗑/g' | \
        awk '{print $0"</span><br>"}')

    cat <<BODYEOF
<html>
<body style="font-family: monospace; background-color: #1e1e1e; color: #d4d4d4; padding: 20px;">
  <div style="max-width: 900px; margin: 0 auto;">
    <div style="background-color: #2d2d2d; border-left: 5px solid ${STATUS_COLOR}; padding: 15px 20px; margin-bottom: 20px; border-radius: 4px;">
      <h2 style="margin: 0; color: ${STATUS_COLOR}; font-family: monospace;">${STATUS_LABEL}</h2>
      <p style="margin: 5px 0 0 0; color: #9e9e9e;">build_push_nightly.sh &mdash; $(date)</p>
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
      Sent by Lobot Cluster Management &mdash; ${SMTP_SERVER}
    </div>
  </div>
</body>
</html>
BODYEOF
}

# ── Main ──────────────────────────────────────────────────────────────────────

> "$LOG_FILE"

if [ "$DRY_RUN" = "true" ]; then
    log "=== DRY RUN — no builds or pushes will happen ==="
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

    IMAGE_SUFFIX="${CUDA}cudnn-${TF}tf-matlab-ollama-claude-qsc-u${UBUNTU}-${DATE}-nightly"
    FLOATING_TAG="${REPO}:${IMAGE_SUFFIX}"
    DATED_TAG="${FLOATING_TAG}-${BUILD_DATE}"

    LOCAL_FLOATING_TAG=""
    LOCAL_DATED_TAG=""
    if [ -n "$LOCAL_REGISTRY" ]; then
        LOCAL_FLOATING_TAG="${LOCAL_REGISTRY}/gpu-jupyter-latest:${IMAGE_SUFFIX}"
        LOCAL_DATED_TAG="${LOCAL_FLOATING_TAG}-${BUILD_DATE}"
    fi

    log "=========================================="
    log " Dockerfile:   $DOCKERFILE"
    log " CUDA:         $CUDA"
    log " Ubuntu:       $UBUNTU"
    log " TensorFlow:   $TF"
    log " Floating tag: $FLOATING_TAG"
    log " Dated tag:    $DATED_TAG"
    if [ -n "$LOCAL_REGISTRY" ]; then
        log " Local:        $LOCAL_FLOATING_TAG"
        log " Local dated:  $LOCAL_DATED_TAG"
    fi
    log "=========================================="

    if [ "$DRY_RUN" = "true" ]; then
        if [ "$PUSH_ONLY" = "true" ]; then
            log "[dry-run] skipping build (--push-only) — would use existing: $FLOATING_TAG"
        else
            log "[dry-run] docker build --platform=linux/amd64 --build-arg CACHE_BUST=$CACHE_BUST -f $DOCKERFILE -t $FLOATING_TAG .build/"
        fi
        log "[dry-run] docker tag $FLOATING_TAG $DATED_TAG"
        if [ "$PUSH_DOCKERHUB" = "true" ]; then
            log "[dry-run] docker push $FLOATING_TAG"
            log "[dry-run] docker push $DATED_TAG"
            log "[dry-run] prune dated tags: keep $KEEP_NIGHTLY_COUNT for *-${DATE}-nightly-*"
        else
            log "[dry-run] skipping DockerHub push (--no-dockerhub)"
        fi
        if [ -n "$LOCAL_REGISTRY" ]; then
            log "[dry-run] docker tag $FLOATING_TAG $LOCAL_FLOATING_TAG"
            log "[dry-run] docker tag $FLOATING_TAG $LOCAL_DATED_TAG"
            log "[dry-run] docker push $LOCAL_FLOATING_TAG"
            log "[dry-run] docker push $LOCAL_DATED_TAG"
        fi
        BUILT_TAGS+=("$FLOATING_TAG" "$DATED_TAG")
        [ -n "$LOCAL_REGISTRY" ] && BUILT_TAGS+=("$LOCAL_FLOATING_TAG" "$LOCAL_DATED_TAG")
    else
        if [ "$PUSH_ONLY" = "true" ]; then
            log "⏭️  Skipping build (--push-only) — using existing local image: $FLOATING_TAG"
            if ! docker image inspect "$FLOATING_TAG" > /dev/null 2>&1; then
                log "❌ Image not found locally: $FLOATING_TAG"
                FAILED=true
                continue
            fi
            docker tag "$FLOATING_TAG" "$DATED_TAG"
            BUILD_OK=true
        elif docker build --platform=linux/amd64 --build-arg CACHE_BUST="$CACHE_BUST" -f "$DOCKERFILE" -t "$FLOATING_TAG" .build/ 2>&1 | tee -a "$LOG_FILE"; then
            docker tag "$FLOATING_TAG" "$DATED_TAG"
            BUILD_OK=true
        else
            log "❌ Build failed: $FLOATING_TAG"
            FAILED=true
            BUILD_OK=false
        fi

        if [ "${BUILD_OK:-false}" = "true" ]; then

            if [ "$PUSH_DOCKERHUB" = "true" ]; then
                PUSH_OK=true
                push_with_retry "$FLOATING_TAG" || PUSH_OK=false
                push_with_retry "$DATED_TAG"    || PUSH_OK=false

                if [ "$PUSH_OK" = "true" ]; then
                    log "✅ Done: $FLOATING_TAG"
                    log "✅ Done: $DATED_TAG"
                    BUILT_TAGS+=("$FLOATING_TAG" "$DATED_TAG")
                    prune_nightly_tags "$DATE" 2>&1 | tee -a "$LOG_FILE"
                else
                    log "❌ Push failed for $FLOATING_TAG / $DATED_TAG"
                    FAILED=true
                fi
            else
                log "⏭️  Skipping DockerHub push (--no-dockerhub)"
            fi

            # Local registry push (independent of DockerHub result)
            if [ -n "$LOCAL_REGISTRY" ]; then
                log "--- Pushing to local registry: $LOCAL_REGISTRY ---"
                docker tag "$FLOATING_TAG" "$LOCAL_FLOATING_TAG"
                docker tag "$FLOATING_TAG" "$LOCAL_DATED_TAG"
                LOCAL_PUSH_OK=true
                push_with_retry "$LOCAL_FLOATING_TAG" || LOCAL_PUSH_OK=false
                push_with_retry "$LOCAL_DATED_TAG"    || LOCAL_PUSH_OK=false
                if [ "$LOCAL_PUSH_OK" = "true" ]; then
                    log "✅ Local: $LOCAL_FLOATING_TAG"
                    log "✅ Local: $LOCAL_DATED_TAG"
                    BUILT_TAGS+=("$LOCAL_FLOATING_TAG" "$LOCAL_DATED_TAG")
                else
                    log "⚠️  Local registry push failed (non-fatal) for $LOCAL_FLOATING_TAG"
                fi
            fi
        fi
    fi

    log ""
done

if [ "$FAILED" = "true" ]; then
    log "=========================================="
    log "❌ One or more builds/pushes failed."
    log "=========================================="
    BODY_TMP=$(mktemp)
    build_email_body "failure" "${BUILT_TAGS[@]:-}" > "$BODY_TMP"
    send_email "❌ Nightly build FAILED | $(date '+%Y-%m-%d')" "$BODY_TMP"
    rm -f "$LOG_FILE"
    exit 1
else
    log "=========================================="
    log "✅ All builds complete."
    log "=========================================="
    BODY_TMP=$(mktemp)
    build_email_body "success" "${BUILT_TAGS[@]}" > "$BODY_TMP"
    send_email "✅ Nightly build complete | $(date '+%Y-%m-%d') | $((${#BUILT_TAGS[@]} / 2)) image(s)" "$BODY_TMP"
    rm -f "$LOG_FILE"
fi

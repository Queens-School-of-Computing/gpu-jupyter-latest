#!/usr/bin/env python3
"""Write component-versions.json and changelog-data.json after a build run.

Called by build_push_qscimages.sh (replacing its old inline manifest heredoc):

  update_image_metadata.py build \
      --new-versions "$NEW_VERSIONS" --build-date "$BUILD_DATE" \
      --events-file "$EVENTS_FILE" --log-file "$LOG_FILE" \
      --dockerfiles .build/Dockerfile.* [--no-manifest] [--skip-known-issues]

and by auto-pull-images.sh on the control plane to attach deploy stats:

  update_image_metadata.py deploy \
      --date 2026-06-11 --nodes-ok 14 --nodes-total 14 --duration 1320

The events file is pipe-separated, one line per build phase:
  RECORD|<image_date>|<type>|<status>|<duration_secs>|<tag>|<log-or-->
with type in {baseline, nightly, full-nightly} and status in
{success, failed, skipped}.

Known-issue lookups hit release-notes sources for the exact versions that
changed in this run; any network failure degrades to a link (or nothing) and
never fails the build.

Stdlib only — no pip dependencies on the build server or control plane.
"""

import argparse
import hashlib
import json
import os
import re
import subprocess
import sys
import urllib.request
from datetime import datetime, timezone

import extract_baseline_pins
import generate_image_changelog

TIMEOUT = 15
HEADERS = {"User-Agent": "qsc-image-build", "Accept": "application/json"}
HOST_NVIDIA_DRIVER = "580"   # cluster GPU nodes run the NVIDIA 580-series driver
KNOWN_ISSUES_MAX_CHARS = 1200
LAYER_CREATED_BY_MAX_CHARS = 120

# component → (github repo, tag candidates for a version)
GITHUB_RELEASES = {
    "code_server": ("coder/code-server", lambda v: [f"v{v}"]),
    "ollama": ("ollama/ollama", lambda v: [f"v{v}"]),
    "opencode": ("sst/opencode", lambda v: [f"v{v}"]),
    "uv": ("astral-sh/uv", lambda v: [v, f"v{v}"]),
    "selenium": ("SeleniumHQ/selenium", lambda v: [f"selenium-{v}"]),
    "tensorflow": ("tensorflow/tensorflow", lambda v: [f"v{v}"]),
    "keras": ("keras-team/keras", lambda v: [f"v{v}"]),
    "pytorch": ("pytorch/pytorch", lambda v: [f"v{v}"]),
    "torchvision": ("pytorch/vision", lambda v: [f"v{v}"]),
    "torchaudio": ("pytorch/audio", lambda v: [f"v{v}"]),
}


def fetch(url, headers=None):
    req = urllib.request.Request(url, headers=headers or HEADERS)
    with urllib.request.urlopen(req, timeout=TIMEOUT) as resp:
        return resp.read().decode("utf-8", errors="replace")


def extract_known_issues_section(body):
    """Pull a 'Known issues' section out of release-notes markdown, if any."""
    m = re.search(
        r"(?ims)^#{1,6}[ \t]*known[ \-]issues?\b[^\n]*\n(.*?)(?=^#{1,6}[ \t]|\Z)", body
    )
    if not m:
        return None
    text = " ".join(m.group(1).split())
    if len(text) > KNOWN_ISSUES_MAX_CHARS:
        text = text[:KNOWN_ISSUES_MAX_CHARS] + "…"
    return text or None


def known_issue_for(component, version):
    """Best-effort known-issues lookup. Returns a dict or None; never raises."""
    issue = {"component": component, "version": version}
    try:
        if component in GITHUB_RELEASES:
            repo, tag_candidates = GITHUB_RELEASES[component]
            for tag in tag_candidates(version):
                try:
                    data = json.loads(
                        fetch(f"https://api.github.com/repos/{repo}/releases/tags/{tag}")
                    )
                except Exception:
                    continue
                issue["url"] = data.get("html_url") or f"https://github.com/{repo}/releases/tag/{tag}"
                notes = extract_known_issues_section(data.get("body") or "")
                issue["notes"] = notes or "none listed in release notes"
                return issue
            issue["url"] = f"https://github.com/{repo}/releases"
            issue["notes"] = "release notes not found for this version"
            return issue

        if component == "claude_code":
            issue["url"] = "https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md"
            body = fetch("https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md")
            m = re.search(
                rf"(?ms)^##\s*{re.escape(version)}\b[^\n]*\n(.*?)(?=^##\s|\Z)", body
            )
            if m:
                notes = extract_known_issues_section(m.group(0))
                issue["notes"] = notes or "see changelog entry (no known-issues section)"
            else:
                issue["notes"] = "changelog entry not found for this version"
            return issue

        if component in ("chrome", "chromedriver"):
            issue["url"] = "https://chromereleases.googleblog.com/search/label/Stable%20updates"
            issue["notes"] = "see Chrome stable release blog"
            return issue

        if component == "vscode":
            parts = version.split(".")
            if len(parts) >= 2:
                issue["url"] = f"https://code.visualstudio.com/updates/v{parts[0]}_{parts[1]}"
            else:
                issue["url"] = "https://code.visualstudio.com/updates"
            issue["notes"] = "see VS Code release notes"
            return issue

        return None
    except Exception as exc:
        issue["notes"] = f"could not fetch release notes ({exc.__class__.__name__})"
        return issue


def parse_events(path):
    records = []
    if not path or not os.path.exists(path):
        return records
    with open(path) as f:
        for line in f:
            parts = line.rstrip("\n").split("|")
            if len(parts) < 6 or parts[0] != "RECORD":
                continue
            rec = {
                "image": parts[1],
                "type": parts[2],
                "status": parts[3],
                "duration_seconds": int(parts[4]) if parts[4].isdigit() else 0,
                "tag": parts[5],
            }
            if len(parts) > 6 and parts[6] not in ("", "-"):
                rec["log"] = parts[6]
            records.append(rec)
    return records


def baseline_tags_from_events(records):
    """image date → baseline tag, derived by stripping nightly suffixes."""
    tags = {}
    for rec in records:
        date, tag = rec["image"], rec["tag"]
        m = re.match(rf"^(.*-{re.escape(date)})(-(?:full)?nightly.*)?$", tag)
        if m:
            tags.setdefault(date, m.group(1))
    return tags


def scan_log(path):
    """Return (warning_count, base_images) from the docker build log."""
    warnings = 0
    base_images = []
    if not path or not os.path.exists(path):
        return warnings, base_images
    seen = set()
    with open(path, errors="replace") as f:
        for line in f:
            if re.search(r"warn(ing)?\b", line, re.IGNORECASE):
                warnings += 1
            for pattern in (r"load metadata for (\S+)", r"^Step \d+/\d+ : FROM (\S+)"):
                m = re.search(pattern, line)
                if m and m.group(1) not in seen:
                    seen.add(m.group(1))
                    base_images.append(m.group(1))
    return warnings, base_images


def docker_layers(tag):
    """Layer listing via docker image history; None when unavailable."""
    try:
        out = subprocess.run(
            ["docker", "image", "history", "--format", "{{json .}}", tag],
            capture_output=True, text=True, timeout=120,
        )
        if out.returncode != 0:
            return None
        layers = []
        for line in out.stdout.splitlines():
            item = json.loads(line)
            created_by = item.get("CreatedBy", "")
            if len(created_by) > LAYER_CREATED_BY_MAX_CHARS:
                created_by = created_by[:LAYER_CREATED_BY_MAX_CHARS] + "…"
            layers.append({"size": item.get("Size", "?"), "created_by": created_by})
        return layers
    except Exception:
        return None


def diff_versions(old, new, scope=""):
    changes = {}
    for name, version in new.items():
        previous = old.get(name)
        if previous != version:
            key = f"{name} ({scope})" if scope else name
            changes[key] = [previous, version]
    return changes


def load_json(path, default):
    if path and os.path.exists(path):
        with open(path) as f:
            return json.load(f)
    return default


def write_json(path, data):
    with open(path, "w") as f:
        json.dump(data, f, indent=2)
        f.write("\n")


def regenerate_md(changelog_data, md_path):
    with open(md_path, "w") as f:
        f.write(generate_image_changelog.render(changelog_data))
        f.write("\n")


def cmd_build(args):
    new_components = json.loads(args.new_versions) if args.new_versions else {}
    old_manifest = load_json(args.versions_file, {})
    records = parse_events(args.events_file)

    pins, missing = extract_baseline_pins.extract(args.dockerfiles)
    for entry in missing:
        print(f"warning: pin not found — {entry}", file=sys.stderr)

    baseline_tags = baseline_tags_from_events(records)
    images = {}
    for date, image_pins in pins["images"].items():
        images[date] = dict(image_pins)
        if date in baseline_tags:
            images[date]["tag"] = baseline_tags[date]

    full_components = json.loads(args.full_versions) if args.full_versions else None

    # ── Manifest ──
    manifest = {
        "build_date": args.build_date,
        "components": new_components,
        "pinned_common": pins["pinned_common"],
        "images": images,
        "constraints": {"host_nvidia_driver": HOST_NVIDIA_DRIVER},
        "dockerfiles": {},
    }
    if full_components:
        manifest["full_components"] = full_components
    for path in args.dockerfiles:
        with open(path, "rb") as f:
            manifest["dockerfiles"][os.path.basename(path)] = hashlib.sha256(f.read()).hexdigest()

    if not args.no_manifest:
        write_json(args.versions_file, manifest)
        print(f"wrote {args.versions_file}")

    # ── Changes (old → new), across nightly components and pins ──
    changes = diff_versions(old_manifest.get("components", {}), new_components)
    changes.update(diff_versions(old_manifest.get("pinned_common", {}), pins["pinned_common"]))
    for date, image_pins in pins["images"].items():
        old_pins = old_manifest.get("images", {}).get(date, {})
        # Only report pin drift when the old manifest already tracked pins,
        # otherwise the first run after this feature lands floods the entry.
        if old_pins:
            changes.update(
                diff_versions(old_pins, image_pins, scope=date)
            )
    if full_components:
        changes.update(
            diff_versions(old_manifest.get("full_components", {}), full_components, scope="full nightly")
        )

    warnings, base_images = scan_log(args.log_file)

    layers = {}
    for rec in records:
        if rec["status"] == "success" and rec["tag"] not in layers and rec["type"] != "baseline":
            tag_layers = docker_layers(rec["tag"])
            if tag_layers:
                layers[rec["tag"]] = tag_layers

    known_issues = []
    if not args.skip_known_issues:
        seen = set()
        for key, (_, version) in sorted(changes.items()):
            component = key.split(" (")[0]
            if component in seen:
                continue
            seen.add(component)
            issue = known_issue_for(component, version)
            if issue:
                known_issues.append(issue)

    entry = {
        "build_date": args.build_date,
        "timestamp": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "builds": records,
        "warnings": warnings,
        "changes": changes,
        "components": {
            "nightly": new_components,
            "pinned_common": pins["pinned_common"],
            "images": images,
        },
        "base_images": base_images,
        "layers": layers,
        "known_issues": known_issues,
    }
    if full_components:
        entry["components"]["full_nightly"] = full_components

    changelog = load_json(args.changelog_data, {"entries": []})
    # One entry per build date: a rerun on the same day replaces its entry
    # but keeps deploy stats the control plane may already have attached.
    existing = next(
        (e for e in changelog["entries"] if e.get("build_date") == args.build_date), None
    )
    if existing:
        if "deployed" in existing:
            entry["deployed"] = existing["deployed"]
        changelog["entries"][changelog["entries"].index(existing)] = entry
    else:
        changelog["entries"].insert(0, entry)

    write_json(args.changelog_data, changelog)
    regenerate_md(changelog, args.changelog_md)
    print(f"wrote {args.changelog_data} and {args.changelog_md}")


def cmd_deploy(args):
    changelog = load_json(args.changelog_data, {"entries": []})
    if not changelog["entries"]:
        print("error: no changelog entries to attach deploy stats to", file=sys.stderr)
        sys.exit(1)

    entry = None
    if args.build_date:
        entry = next(
            (e for e in changelog["entries"] if e.get("build_date") == args.build_date), None
        )
        if entry is None:
            print(f"error: no changelog entry for build date {args.build_date}", file=sys.stderr)
            sys.exit(1)
    else:
        entry = changelog["entries"][0]

    entry["deployed"] = {
        "date": args.date,
        "nodes_ok": args.nodes_ok,
        "nodes_total": args.nodes_total,
        "duration_seconds": args.duration,
    }
    write_json(args.changelog_data, changelog)
    regenerate_md(changelog, args.changelog_md)
    print(f"attached deploy stats to build {entry.get('build_date')}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)

    p_build = sub.add_parser("build", help="record a build run (build server)")
    p_build.add_argument("--versions-file", default="component-versions.json")
    p_build.add_argument("--changelog-data", default="changelog-data.json")
    p_build.add_argument("--changelog-md", default="IMAGE-CHANGELOG.md")
    p_build.add_argument("--new-versions", required=True, help="resolver output JSON")
    p_build.add_argument("--full-versions", default=None, help="full-nightly resolver output JSON")
    p_build.add_argument("--build-date", required=True)
    p_build.add_argument("--events-file", default=None)
    p_build.add_argument("--log-file", default=None)
    p_build.add_argument("--dockerfiles", nargs="+", required=True)
    p_build.add_argument("--no-manifest", action="store_true",
                         help="record the changelog entry without rewriting the manifest (failed runs)")
    p_build.add_argument("--skip-known-issues", action="store_true")
    p_build.set_defaults(func=cmd_build)

    p_deploy = sub.add_parser("deploy", help="attach deploy stats (control plane)")
    p_deploy.add_argument("--changelog-data", default="changelog-data.json")
    p_deploy.add_argument("--changelog-md", default="IMAGE-CHANGELOG.md")
    p_deploy.add_argument("--date", required=True, help="deploy date, YYYY-MM-DD")
    p_deploy.add_argument("--nodes-ok", type=int, required=True)
    p_deploy.add_argument("--nodes-total", type=int, required=True)
    p_deploy.add_argument("--duration", type=int, default=0, help="seconds")
    p_deploy.add_argument("--build-date", default=None, help="target entry; default newest")
    p_deploy.set_defaults(func=cmd_deploy)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()

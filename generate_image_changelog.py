#!/usr/bin/env python3
"""Render IMAGE-CHANGELOG.md from changelog-data.json.

changelog-data.json is the single source of truth for build/deploy history;
it is written by two independent processes that each call this script after
editing it:

  - update_image_metadata.py on the build server (adds a build entry per run)
  - auto-pull-images.sh on the control plane (adds deploy stats to an entry)

Never edit IMAGE-CHANGELOG.md by hand — it is regenerated wholesale.

Usage: generate_image_changelog.py [changelog-data.json] [IMAGE-CHANGELOG.md]

Stdlib only — no pip dependencies on the build server or control plane.
"""

import json
import sys

STATUS_ICONS = {"success": "✅", "failed": "❌", "skipped": "⏭️"}

HEADER = """\
# QSC Image Changelog

Build and deployment history for the Lobot JupyterLab images. See
[IMAGE-COMPONENTS.md](IMAGE-COMPONENTS.md) for what's in each image and
[component-versions.json](component-versions.json) for current versions.

<!-- GENERATED FILE — do not edit. Edit changelog-data.json and run
     generate_image_changelog.py instead. -->
"""


def fmt_duration(seconds):
    seconds = int(seconds)
    h, rem = divmod(seconds, 3600)
    m, s = divmod(rem, 60)
    if h:
        return f"{h}h {m}m"
    if m:
        return f"{m}m {s}s"
    return f"{s}s"


def fmt_date(yyyymmdd):
    s = str(yyyymmdd)
    return f"{s[0:4]}-{s[4:6]}-{s[6:8]}" if len(s) == 8 and s.isdigit() else s


def render_builds_line(entry):
    parts = []
    for b in entry.get("builds", []):
        icon = STATUS_ICONS.get(b.get("status", ""), b.get("status", "?"))
        seg = f"{b.get('image', '?')} {b.get('type', '')} {icon}"
        if b.get("status") == "success" and b.get("duration_seconds"):
            seg += f" {fmt_duration(b['duration_seconds'])}"
        if b.get("status") == "failed" and b.get("log"):
            seg += f" (log: `{b['log']}`)"
        parts.append(seg)
    line = " · ".join(parts) if parts else "no builds recorded"
    warnings = entry.get("warnings")
    if warnings:
        line += f" — warnings in build log: {warnings}"
    return line


def render_entry(entry):
    out = [f"## {fmt_date(entry.get('build_date', '?'))}", ""]
    out.append(f"**Build:** {render_builds_line(entry)}")

    changes = entry.get("changes", {})
    if changes:
        segs = [f"`{name}` {old or '(new)'} → {new}" for name, (old, new) in sorted(changes.items())]
        out.append(f"**Changed:** {' · '.join(segs)}")
    else:
        out.append("**Changed:** nothing — versions unchanged")

    deployed = entry.get("deployed")
    if deployed:
        seg = f"{deployed.get('date', '?')} · {deployed.get('nodes_ok', '?')}/{deployed.get('nodes_total', '?')} nodes"
        if deployed.get("duration_seconds"):
            seg += f" · {fmt_duration(deployed['duration_seconds'])}"
        out.append(f"**Deployed:** {seg}")

    issues = entry.get("known_issues", [])
    if issues:
        out.append("**Known issues (for the versions in this build):**")
        for issue in issues:
            line = f"- `{issue.get('component', '?')}` {issue.get('version', '?')}"
            if issue.get("url"):
                line += f" — [release notes]({issue['url']})"
            if issue.get("notes"):
                line += f" — {issue['notes']}"
            out.append(line)

    components = entry.get("components", {})
    if components:
        out.append("")
        out.append("<details>")
        out.append(f"<summary>Full component list ({fmt_date(entry.get('build_date', '?'))})</summary>")
        out.append("")
        out.append("| Component | Version | Scope |")
        out.append("|-----------|---------|-------|")
        for name, version in sorted(components.get("nightly", {}).items()):
            out.append(f"| `{name}` | {version} | nightly tools |")
        for name, version in sorted(components.get("pinned_common", {}).items()):
            out.append(f"| `{name}` | {version} | pinned, all images |")
        for image, pins in sorted(components.get("images", {}).items()):
            for name, version in sorted(pins.items()):
                if name == "tag":
                    continue
                out.append(f"| `{name}` | {version} | pinned, {image} |")
        out.append("")
        out.append("</details>")

    base_images = entry.get("base_images", [])
    layers = entry.get("layers", {})
    if base_images or layers:
        out.append("")
        out.append("<details>")
        out.append("<summary>Layers &amp; base images</summary>")
        out.append("")
        if base_images:
            out.append("Base images downloaded:")
            for img in base_images:
                out.append(f"- `{img}`")
            out.append("")
        for tag, tag_layers in layers.items():
            out.append(f"**`{tag}`** ({len(tag_layers)} layers)")
            out.append("")
            out.append("| Size | Created by |")
            out.append("|------|------------|")
            for layer in tag_layers:
                created_by = layer.get("created_by", "").replace("|", "\\|")
                out.append(f"| {layer.get('size', '?')} | <sub>`{created_by}`</sub> |")
            out.append("")
        out.append("</details>")

    out.append("")
    return "\n".join(out)


def render(data):
    entries = sorted(
        data.get("entries", []),
        key=lambda e: str(e.get("build_date", "")),
        reverse=True,
    )
    return HEADER + "\n---\n\n" + "\n---\n\n".join(render_entry(e) for e in entries)


def main():
    data_path = sys.argv[1] if len(sys.argv) > 1 else "changelog-data.json"
    md_path = sys.argv[2] if len(sys.argv) > 2 else "IMAGE-CHANGELOG.md"
    with open(data_path) as f:
        data = json.load(f)
    with open(md_path, "w") as f:
        f.write(render(data))
        f.write("\n")
    print(f"wrote {md_path} ({len(data.get('entries', []))} entries)")


if __name__ == "__main__":
    main()

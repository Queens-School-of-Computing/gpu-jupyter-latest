#!/usr/bin/env python3
"""Extract the pinned baseline component versions from the dated Dockerfiles.

Used by update_image_metadata.py to record the pinned stack (CUDA, TensorFlow,
PyTorch, MATLAB, Jupyter extensions, TurboVNC, ...) in component-versions.json
alongside the nightly-refreshed components. Parsing the Dockerfiles instead of
editing them keeps their hashes stable, so recording pins never forces a
rebuild.

Per-image keys come from each Dockerfile; common keys are expected to match
across all Dockerfiles — a mismatch prints a warning to stderr and the value
from the newest Dockerfile wins.

Usage: extract_baseline_pins.py .build/Dockerfile.20260313 .build/Dockerfile.20260424
Prints a JSON object: {"images": {<date>: {...}}, "pinned_common": {...}}

Stdlib only — no pip dependencies on the build server.
"""

import json
import os
import re
import sys

# (key, regex) applied per non-comment line. Per-image: stacks that differ
# between image lines (or could). Common: identical across all images.
PER_IMAGE_PATTERNS = [
    ("cuda", re.compile(r"^FROM\s+nvidia/cuda:(\d+\.\d+\.\d+)")),
    ("ubuntu", re.compile(r"^FROM\s+nvidia/cuda:[\w.-]*ubuntu(\d+\.\d+)")),
    ("python", re.compile(r"^ARG\s+PYTHON_VERSION=(\S+)")),
    ("tensorflow", re.compile(r"\btensorflow==([\w.]+)")),
    ("keras", re.compile(r"\bkeras==([\w.]+)")),
    ("pytorch", re.compile(r"\btorch==([\w.]+)")),
    ("torchvision", re.compile(r"\btorchvision==([\w.]+)")),
    ("torchaudio", re.compile(r"\btorchaudio==([\w.]+)")),
    ("torch_cuda_line", re.compile(r"download\.pytorch\.org/whl/(cu\d+)")),
]

COMMON_PATTERNS = [
    ("matlab", re.compile(r"^ARG\s+MATLAB_RELEASE=(\S+)")),
    ("jupyterlab_git", re.compile(r"\bjupyterlab-git==([\w.]+)")),
    ("plotly", re.compile(r"\bplotly==([\w.]+)")),
    ("ipyleaflet", re.compile(r"\bipyleaflet==([\w.]+)")),
    ("ipywidgets", re.compile(r"\bipywidgets==([\w.]+)")),
    ("jupyterlab_spellchecker", re.compile(r"\bjupyterlab-spellchecker==([\w.]+)")),
    ("turbovnc", re.compile(r"turbovnc_([\d.]+)_amd64\.deb")),
]


def parse_dockerfile(path):
    """Return {key: version} for every pattern that matches a non-comment line.

    First match wins per key, matching the build script's grep|head -1 idiom,
    so commented-out historical pins further down can never override.
    """
    found = {}
    with open(path) as f:
        for line in f:
            if line.lstrip().startswith("#"):
                continue
            for key, pattern in PER_IMAGE_PATTERNS + COMMON_PATTERNS:
                if key in found:
                    continue
                m = pattern.search(line)
                if m:
                    found[key] = m.group(1)
    return found


def extract(dockerfiles):
    """Return ({"images": ..., "pinned_common": ...}, [missing pin descriptions])."""
    images = {}
    common = {}
    missing = []
    for path in sorted(dockerfiles):
        date_m = re.search(r"(\d{8})$", os.path.basename(path))
        if not date_m:
            print(f"error: no YYYYMMDD date in Dockerfile name: {path}", file=sys.stderr)
            sys.exit(1)
        date = date_m.group(1)

        found = parse_dockerfile(path)
        per_image = {}
        for key, _ in PER_IMAGE_PATTERNS:
            if key in found:
                per_image[key] = found[key]
            else:
                missing.append(f"{os.path.basename(path)}: {key}")
        images[date] = per_image

        for key, _ in COMMON_PATTERNS:
            if key not in found:
                missing.append(f"{os.path.basename(path)}: {key}")
                continue
            if key in common and common[key] != found[key]:
                print(
                    f"warning: {key} differs across Dockerfiles "
                    f"({common[key]} vs {found[key]} in {os.path.basename(path)}) — using {found[key]}",
                    file=sys.stderr,
                )
            common[key] = found[key]  # sorted input: newest Dockerfile wins

    return {"images": images, "pinned_common": common}, missing


def main():
    dockerfiles = sys.argv[1:]
    if not dockerfiles:
        print("usage: extract_baseline_pins.py <Dockerfile.YYYYMMDD> [...]", file=sys.stderr)
        sys.exit(1)

    pins, missing = extract(dockerfiles)
    if missing:
        for entry in missing:
            print(f"error: pin not found — {entry}", file=sys.stderr)
        sys.exit(1)

    json.dump(pins, sys.stdout, indent=2)
    print()


if __name__ == "__main__":
    main()

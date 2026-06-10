#!/usr/bin/env python3
"""Resolve the latest upstream version of each nightly-refreshed image component.

Used by build_push_qscimages.sh before the nightly phase: the output is
compared against component-versions.json to decide whether a rebuild is
needed, and the values are passed to docker build as
--build-arg <COMPONENT>_VERSION=<version>.

Prints a JSON object to stdout, keys in image layer order (least to most
frequently updated). Any resolution failure prints to stderr and exits 1.

Stdlib only — no pip dependencies on the build server.
"""

import json
import sys
import urllib.request

TIMEOUT = 30
HEADERS = {"User-Agent": "qsc-image-build", "Accept": "application/json"}


def fetch_json(url):
    req = urllib.request.Request(url, headers=HEADERS)
    with urllib.request.urlopen(req, timeout=TIMEOUT) as resp:
        return json.load(resp)


def github_latest_release(repo):
    data = fetch_json(f"https://api.github.com/repos/{repo}/releases/latest")
    return data["tag_name"].lstrip("v")


def chrome_stable():
    data = fetch_json(
        "https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions.json"
    )
    return data["channels"]["Stable"]["version"]


def main():
    # Layer order: least → most frequently updated. chromedriver reuses the
    # chrome lookup so the two can never mismatch.
    resolvers = {
        "selenium": lambda: fetch_json("https://pypi.org/pypi/selenium/json")["info"]["version"],
        "vscode": lambda: fetch_json(
            "https://update.code.visualstudio.com/api/update/linux-deb-x64/stable/latest"
        )["productVersion"],
        "code_server": lambda: github_latest_release("coder/code-server"),
        "chrome": chrome_stable,
        "chromedriver": lambda: versions["chrome"],
        "ollama": lambda: github_latest_release("ollama/ollama"),
        "opencode": lambda: github_latest_release("sst/opencode"),
        "uv": lambda: github_latest_release("astral-sh/uv"),
        "claude_code": lambda: fetch_json(
            "https://registry.npmjs.org/@anthropic-ai/claude-code/latest"
        )["version"],
    }

    versions = {}
    errors = []
    for name, resolve in resolvers.items():
        try:
            versions[name] = resolve()
        except Exception as exc:
            errors.append(f"{name}: {exc}")

    if errors:
        for err in errors:
            print(f"error: could not resolve {err}", file=sys.stderr)
        sys.exit(1)

    json.dump(versions, sys.stdout, indent=2)
    print()


if __name__ == "__main__":
    main()

# QSC Image Changelog

Build and deployment history for the Lobot JupyterLab images. See
[IMAGE-COMPONENTS.md](IMAGE-COMPONENTS.md) for what's in each image and
[component-versions.json](component-versions.json) for current versions.

<!-- GENERATED FILE — do not edit. Edit changelog-data.json and run
     generate_image_changelog.py instead. -->

---

## 2026-06-11

**Build:** 20260313 full-nightly ✅ 1h 20m · 20260424 full-nightly ✅ 1h 7m — warnings in build log: 200
**Changed:** `chrome (full nightly)` (new) → 149.0.7827.55 · `chromedriver (full nightly)` (new) → 149.0.7827.55 · `claude_code (full nightly)` (new) → 2.1.173 · `code_server (full nightly)` (new) → 4.123.0 · `ipyleaflet` (new) → 0.19.2 · `ipywidgets` (new) → 8.1.5 · `jupyterlab_git` (new) → 0.51.3 · `jupyterlab_spellchecker` (new) → 0.8.4 · `matlab` (new) → R2024b · `ollama (full nightly)` (new) → 0.30.7 · `opencode (full nightly)` (new) → 1.17.3 · `plotly` (new) → 5.24.1 · `selenium (full nightly)` (new) → 4.44.0 · `turbovnc` (new) → 3.3 · `uv (full nightly)` (new) → 0.11.20 · `vscode (full nightly)` (new) → 1.124.0
**Known issues (for the versions in this build):**
- `chrome` 149.0.7827.55 — [release notes](https://chromereleases.googleblog.com/search/label/Stable%20updates) — see Chrome stable release blog
- `chromedriver` 149.0.7827.55 — [release notes](https://chromereleases.googleblog.com/search/label/Stable%20updates) — see Chrome stable release blog
- `claude_code` 2.1.173 — [release notes](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md) — see changelog entry (no known-issues section)
- `code_server` 4.123.0 — [release notes](https://github.com/coder/code-server/releases/tag/v4.123.0) — none listed in release notes
- `ollama` 0.30.7 — [release notes](https://github.com/ollama/ollama/releases/tag/v0.30.7) — none listed in release notes
- `opencode` 1.17.3 — [release notes](https://github.com/anomalyco/opencode/releases/tag/v1.17.3) — none listed in release notes
- `selenium` 4.44.0 — [release notes](https://github.com/SeleniumHQ/selenium/releases/tag/selenium-4.44.0) — none listed in release notes
- `uv` 0.11.20 — [release notes](https://github.com/astral-sh/uv/releases/tag/0.11.20) — none listed in release notes
- `vscode` 1.124.0 — [release notes](https://code.visualstudio.com/updates/v1_124) — see VS Code release notes

<details>
<summary>Full component list (2026-06-11)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 149.0.7827.55 | nightly tools |
| `chromedriver` | 149.0.7827.55 | nightly tools |
| `claude_code` | 2.1.173 | nightly tools |
| `code_server` | 4.123.0 | nightly tools |
| `ollama` | 0.30.7 | nightly tools |
| `opencode` | 1.17.3 | nightly tools |
| `selenium` | 4.44.0 | nightly tools |
| `uv` | 0.11.20 | nightly tools |
| `vscode` | 1.124.0 | nightly tools |
| `ipyleaflet` | 0.19.2 | pinned, all images |
| `ipywidgets` | 8.1.5 | pinned, all images |
| `jupyterlab_git` | 0.51.3 | pinned, all images |
| `jupyterlab_spellchecker` | 0.8.4 | pinned, all images |
| `matlab` | R2024b | pinned, all images |
| `plotly` | 5.24.1 | pinned, all images |
| `turbovnc` | 3.3 | pinned, all images |
| `cuda` | 13.0.2 | pinned, 20260313 |
| `keras` | 3.13.0 | pinned, 20260313 |
| `python` | 3.12 | pinned, 20260313 |
| `pytorch` | 2.9.1 | pinned, 20260313 |
| `tensorflow` | 2.20.0 | pinned, 20260313 |
| `torch_cuda_line` | cu126 | pinned, 20260313 |
| `torchaudio` | 2.9.1 | pinned, 20260313 |
| `torchvision` | 0.24.1 | pinned, 20260313 |
| `ubuntu` | 24.04 | pinned, 20260313 |
| `cuda` | 13.2.1 | pinned, 20260424 |
| `keras` | 3.13.0 | pinned, 20260424 |
| `python` | 3.12 | pinned, 20260424 |
| `pytorch` | 2.11.0 | pinned, 20260424 |
| `tensorflow` | 2.20.0 | pinned, 20260424 |
| `torch_cuda_line` | cu126 | pinned, 20260424 |
| `torchaudio` | 2.11.0 | pinned, 20260424 |
| `torchvision` | 0.26.0 | pinned, 20260424 |
| `ubuntu` | 24.04 | pinned, 20260424 |

</details>

<details>
<summary>Layers &amp; base images</summary>

Base images downloaded:
- `docker.io/nvidia/cuda:13.0.2-cudnn-runtime-ubuntu24.04`
- `docker.io/nvidia/cuda:13.2.1-cudnn-runtime-ubuntu24.04`

</details>


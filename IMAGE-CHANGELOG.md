# QSC Image Changelog

Build and deployment history for the Lobot JupyterLab images. See
[IMAGE-COMPONENTS.md](IMAGE-COMPONENTS.md) for what's in each image and
[component-versions.json](component-versions.json) for current versions.

<!-- GENERATED FILE — do not edit. Edit changelog-data.json and run
     generate_image_changelog.py instead. -->

---

## 2026-06-15

**Build:** 20260313 nightly ✅ 4m 50s · 20260424 nightly ✅ 5m 20s
**Changed:** `opencode` 1.17.6 → 1.17.7
**Known issues (for the versions in this build):**
- `opencode` 1.17.7 — [release notes](https://github.com/anomalyco/opencode/releases/tag/v1.17.7) — none listed in release notes

<details>
<summary>Full component list (2026-06-15)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 149.0.7827.115 | nightly tools |
| `chromedriver` | 149.0.7827.115 | nightly tools |
| `claude_code` | 2.1.177 | nightly tools |
| `code_server` | 4.123.0 | nightly tools |
| `ollama` | 0.30.8 | nightly tools |
| `opencode` | 1.17.7 | nightly tools |
| `selenium` | 4.44.0 | nightly tools |
| `uv` | 0.11.21 | nightly tools |
| `vscode` | 1.124.2 | nightly tools |
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

---

## 2026-06-14

**Build:** 20260313 nightly ✅ 4m 58s · 20260424 nightly ✅ 5m 22s
**Changed:** `opencode` 1.17.4 → 1.17.6
**Known issues (for the versions in this build):**
- `opencode` 1.17.6 — [release notes](https://github.com/anomalyco/opencode/releases/tag/v1.17.6) — none listed in release notes

<details>
<summary>Full component list (2026-06-14)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 149.0.7827.115 | nightly tools |
| `chromedriver` | 149.0.7827.115 | nightly tools |
| `claude_code` | 2.1.177 | nightly tools |
| `code_server` | 4.123.0 | nightly tools |
| `ollama` | 0.30.8 | nightly tools |
| `opencode` | 1.17.6 | nightly tools |
| `selenium` | 4.44.0 | nightly tools |
| `uv` | 0.11.21 | nightly tools |
| `vscode` | 1.124.2 | nightly tools |
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

---

## 2026-06-13

**Build:** 20260313 nightly ✅ 7m 32s · 20260424 nightly ✅ 7m 53s — warnings in build log: 4
**Changed:** `claude_code` 2.1.175 → 2.1.177 · `ollama` 0.30.7 → 0.30.8
**Known issues (for the versions in this build):**
- `claude_code` 2.1.177 — [release notes](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md) — changelog entry not found for this version
- `ollama` 0.30.8 — [release notes](https://github.com/ollama/ollama/releases/tag/v0.30.8) — none listed in release notes

<details>
<summary>Full component list (2026-06-13)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 149.0.7827.115 | nightly tools |
| `chromedriver` | 149.0.7827.115 | nightly tools |
| `claude_code` | 2.1.177 | nightly tools |
| `code_server` | 4.123.0 | nightly tools |
| `ollama` | 0.30.8 | nightly tools |
| `opencode` | 1.17.4 | nightly tools |
| `selenium` | 4.44.0 | nightly tools |
| `uv` | 0.11.21 | nightly tools |
| `vscode` | 1.124.2 | nightly tools |
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

---

## 2026-06-12

**Build:** 20260313 nightly ✅ 10m 31s · 20260424 nightly ✅ 10m 4s — warnings in build log: 8
**Changed:** `claude_code` 2.1.174 → 2.1.175 · `vscode` 1.124.0 → 1.124.2
**Known issues (for the versions in this build):**
- `claude_code` 2.1.175 — [release notes](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md) — see changelog entry (no known-issues section)
- `vscode` 1.124.2 — [release notes](https://code.visualstudio.com/updates/v1_124) — see VS Code release notes

<details>
<summary>Full component list (2026-06-12)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 149.0.7827.115 | nightly tools |
| `chromedriver` | 149.0.7827.115 | nightly tools |
| `claude_code` | 2.1.175 | nightly tools |
| `code_server` | 4.123.0 | nightly tools |
| `ollama` | 0.30.7 | nightly tools |
| `opencode` | 1.17.4 | nightly tools |
| `selenium` | 4.44.0 | nightly tools |
| `uv` | 0.11.21 | nightly tools |
| `vscode` | 1.124.2 | nightly tools |
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

---

## 2026-06-11

**Build:** 20260313 full-nightly ✅ 1h 1m · 20260424 full-nightly ✅ 1h 0m — warnings in build log: 200
**Changed:** `chrome` 149.0.7827.55 → 149.0.7827.115 · `chrome (full nightly)` 149.0.7827.55 → 149.0.7827.115 · `chromedriver` 149.0.7827.55 → 149.0.7827.115 · `chromedriver (full nightly)` 149.0.7827.55 → 149.0.7827.115 · `claude_code` 2.1.173 → 2.1.174 · `claude_code (full nightly)` 2.1.173 → 2.1.174 · `opencode` 1.17.3 → 1.17.4 · `opencode (full nightly)` 1.17.3 → 1.17.4 · `uv` 0.11.20 → 0.11.21 · `uv (full nightly)` 0.11.20 → 0.11.21
**Known issues (for the versions in this build):**
- `chrome` 149.0.7827.115 — [release notes](https://chromereleases.googleblog.com/search/label/Stable%20updates) — see Chrome stable release blog
- `chromedriver` 149.0.7827.115 — [release notes](https://chromereleases.googleblog.com/search/label/Stable%20updates) — see Chrome stable release blog
- `claude_code` 2.1.174 — [release notes](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md) — see changelog entry (no known-issues section)
- `opencode` 1.17.4 — [release notes](https://github.com/anomalyco/opencode/releases/tag/v1.17.4) — none listed in release notes
- `uv` 0.11.21 — [release notes](https://github.com/astral-sh/uv/releases/tag/0.11.21) — none listed in release notes

<details>
<summary>Full component list (2026-06-11)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 149.0.7827.115 | nightly tools |
| `chromedriver` | 149.0.7827.115 | nightly tools |
| `claude_code` | 2.1.174 | nightly tools |
| `code_server` | 4.123.0 | nightly tools |
| `ollama` | 0.30.7 | nightly tools |
| `opencode` | 1.17.4 | nightly tools |
| `selenium` | 4.44.0 | nightly tools |
| `uv` | 0.11.21 | nightly tools |
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


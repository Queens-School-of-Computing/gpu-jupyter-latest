# QSC Image Changelog

Build and deployment history for the Lobot JupyterLab images. See
[IMAGE-COMPONENTS.md](IMAGE-COMPONENTS.md) for what's in each image and
[component-versions.json](component-versions.json) for current versions.

<!-- GENERATED FILE — do not edit. Edit changelog-data.json and run
     generate_image_changelog.py instead. -->

---

## 2026-08-05

**Build:** 20260313 nightly ✅ 8m 56s · 20260424 nightly ✅ 8m 51s — warnings in build log: 14
**Changed:** `chrome` 151.0.7922.71 → 151.0.7922.76 · `chromedriver` 151.0.7922.71 → 151.0.7922.76 · `claude_code` 2.1.221 → 2.1.222 · `opencode` 1.18.12 → 1.18.13
**Known issues (for the versions in this build):**
- `chrome` 151.0.7922.76 — [release notes](https://chromereleases.googleblog.com/search/label/Stable%20updates) — see Chrome stable release blog
- `chromedriver` 151.0.7922.76 — [release notes](https://chromereleases.googleblog.com/search/label/Stable%20updates) — see Chrome stable release blog
- `claude_code` 2.1.222 — [release notes](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md) — see changelog entry (no known-issues section)
- `opencode` 1.18.13 — [release notes](https://github.com/anomalyco/opencode/releases/tag/v1.18.13) — none listed in release notes

<details>
<summary>Full component list (2026-08-05)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 151.0.7922.76 | nightly tools |
| `chromedriver` | 151.0.7922.76 | nightly tools |
| `claude_code` | 2.1.222 | nightly tools |
| `code_server` | 4.131.0 | nightly tools |
| `ollama` | 0.32.5 | nightly tools |
| `opencode` | 1.18.13 | nightly tools |
| `selenium` | 4.46.0 | nightly tools |
| `uv` | 0.12.1 | nightly tools |
| `vscode` | 1.131.0 | nightly tools |
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

## 2026-08-04

**Build:** 20260313 nightly ✅ 5m 24s · 20260424 nightly ✅ 5m 16s — warnings in build log: 10
**Changed:** `claude_code` 2.1.220 → 2.1.221 · `opencode` 1.18.11 → 1.18.12
**Known issues (for the versions in this build):**
- `claude_code` 2.1.221 — [release notes](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md) — see changelog entry (no known-issues section)
- `opencode` 1.18.12 — [release notes](https://github.com/anomalyco/opencode/releases/tag/v1.18.12) — none listed in release notes

<details>
<summary>Full component list (2026-08-04)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 151.0.7922.71 | nightly tools |
| `chromedriver` | 151.0.7922.71 | nightly tools |
| `claude_code` | 2.1.221 | nightly tools |
| `code_server` | 4.131.0 | nightly tools |
| `ollama` | 0.32.5 | nightly tools |
| `opencode` | 1.18.12 | nightly tools |
| `selenium` | 4.46.0 | nightly tools |
| `uv` | 0.12.1 | nightly tools |
| `vscode` | 1.131.0 | nightly tools |
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

## 2026-08-02

**Build:** 20260313 nightly ✅ 13m 0s · 20260424 nightly ✅ 12m 56s — warnings in build log: 10
**Changed:** `opencode` 1.18.10 → 1.18.11
**Known issues (for the versions in this build):**
- `opencode` 1.18.11 — [release notes](https://github.com/anomalyco/opencode/releases/tag/v1.18.11) — none listed in release notes

<details>
<summary>Full component list (2026-08-02)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 151.0.7922.71 | nightly tools |
| `chromedriver` | 151.0.7922.71 | nightly tools |
| `claude_code` | 2.1.220 | nightly tools |
| `code_server` | 4.131.0 | nightly tools |
| `ollama` | 0.32.5 | nightly tools |
| `opencode` | 1.18.11 | nightly tools |
| `selenium` | 4.46.0 | nightly tools |
| `uv` | 0.12.1 | nightly tools |
| `vscode` | 1.131.0 | nightly tools |
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

## 2026-08-01

**Build:** 20260313 nightly ✅ 5m 10s · 20260424 nightly ✅ 4m 59s — warnings in build log: 10
**Changed:** `uv` 0.12.0 → 0.12.1
**Known issues (for the versions in this build):**
- `uv` 0.12.1 — [release notes](https://github.com/astral-sh/uv/releases/tag/0.12.1) — none listed in release notes

<details>
<summary>Full component list (2026-08-01)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 151.0.7922.71 | nightly tools |
| `chromedriver` | 151.0.7922.71 | nightly tools |
| `claude_code` | 2.1.220 | nightly tools |
| `code_server` | 4.131.0 | nightly tools |
| `ollama` | 0.32.5 | nightly tools |
| `opencode` | 1.18.10 | nightly tools |
| `selenium` | 4.46.0 | nightly tools |
| `uv` | 0.12.1 | nightly tools |
| `vscode` | 1.131.0 | nightly tools |
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

## 2026-07-31

**Build:** 20260313 nightly ✅ 9m 39s · 20260424 nightly ✅ 9m 33s — warnings in build log: 18
**Changed:** `code_server` 4.130.0 → 4.131.0 · `opencode` 1.18.9 → 1.18.10
**Known issues (for the versions in this build):**
- `code_server` 4.131.0 — [release notes](https://github.com/coder/code-server/releases/tag/v4.131.0) — none listed in release notes
- `opencode` 1.18.10 — [release notes](https://github.com/anomalyco/opencode/releases/tag/v1.18.10) — none listed in release notes

<details>
<summary>Full component list (2026-07-31)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 151.0.7922.71 | nightly tools |
| `chromedriver` | 151.0.7922.71 | nightly tools |
| `claude_code` | 2.1.220 | nightly tools |
| `code_server` | 4.131.0 | nightly tools |
| `ollama` | 0.32.5 | nightly tools |
| `opencode` | 1.18.10 | nightly tools |
| `selenium` | 4.46.0 | nightly tools |
| `uv` | 0.12.0 | nightly tools |
| `vscode` | 1.131.0 | nightly tools |
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

## 2026-07-30

**Build:** 20260313 nightly ✅ 11m 42s · 20260424 nightly ✅ 11m 41s — warnings in build log: 18
**Changed:** `chrome` 151.0.7922.47 → 151.0.7922.71 · `chromedriver` 151.0.7922.47 → 151.0.7922.71 · `vscode` 1.130.0 → 1.131.0
**Known issues (for the versions in this build):**
- `chrome` 151.0.7922.71 — [release notes](https://chromereleases.googleblog.com/search/label/Stable%20updates) — see Chrome stable release blog
- `chromedriver` 151.0.7922.71 — [release notes](https://chromereleases.googleblog.com/search/label/Stable%20updates) — see Chrome stable release blog
- `vscode` 1.131.0 — [release notes](https://code.visualstudio.com/updates/v1_131) — see VS Code release notes

<details>
<summary>Full component list (2026-07-30)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 151.0.7922.71 | nightly tools |
| `chromedriver` | 151.0.7922.71 | nightly tools |
| `claude_code` | 2.1.220 | nightly tools |
| `code_server` | 4.130.0 | nightly tools |
| `ollama` | 0.32.5 | nightly tools |
| `opencode` | 1.18.9 | nightly tools |
| `selenium` | 4.46.0 | nightly tools |
| `uv` | 0.12.0 | nightly tools |
| `vscode` | 1.131.0 | nightly tools |
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

## 2026-07-29

**Build:** 20260313 nightly ✅ 4m 57s · 20260424 nightly ✅ 5m 13s — warnings in build log: 10
**Changed:** `opencode` 1.18.7 → 1.18.9 · `uv` 0.11.32 → 0.12.0
**Known issues (for the versions in this build):**
- `opencode` 1.18.9 — [release notes](https://github.com/anomalyco/opencode/releases/tag/v1.18.9) — none listed in release notes
- `uv` 0.12.0 — [release notes](https://github.com/astral-sh/uv/releases/tag/0.12.0) — none listed in release notes

<details>
<summary>Full component list (2026-07-29)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 151.0.7922.47 | nightly tools |
| `chromedriver` | 151.0.7922.47 | nightly tools |
| `claude_code` | 2.1.220 | nightly tools |
| `code_server` | 4.130.0 | nightly tools |
| `ollama` | 0.32.5 | nightly tools |
| `opencode` | 1.18.9 | nightly tools |
| `selenium` | 4.46.0 | nightly tools |
| `uv` | 0.12.0 | nightly tools |
| `vscode` | 1.130.0 | nightly tools |
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

## 2026-07-28

**Build:** 20260313 nightly ✅ 8m 0s · 20260424 nightly ✅ 8m 6s — warnings in build log: 14
**Changed:** `ollama` 0.32.4 → 0.32.5 · `opencode` 1.18.6 → 1.18.7
**Known issues (for the versions in this build):**
- `ollama` 0.32.5 — [release notes](https://github.com/ollama/ollama/releases/tag/v0.32.5) — none listed in release notes
- `opencode` 1.18.7 — [release notes](https://github.com/anomalyco/opencode/releases/tag/v1.18.7) — none listed in release notes

<details>
<summary>Full component list (2026-07-28)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 151.0.7922.47 | nightly tools |
| `chromedriver` | 151.0.7922.47 | nightly tools |
| `claude_code` | 2.1.220 | nightly tools |
| `code_server` | 4.130.0 | nightly tools |
| `ollama` | 0.32.5 | nightly tools |
| `opencode` | 1.18.7 | nightly tools |
| `selenium` | 4.46.0 | nightly tools |
| `uv` | 0.11.32 | nightly tools |
| `vscode` | 1.130.0 | nightly tools |
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

## 2026-07-27

**Build:** 20260313 nightly ✅ 5m 6s · 20260424 nightly ✅ 5m 19s — warnings in build log: 10
**Changed:** `opencode` 1.18.5 → 1.18.6
**Known issues (for the versions in this build):**
- `opencode` 1.18.6 — [release notes](https://github.com/anomalyco/opencode/releases/tag/v1.18.6) — none listed in release notes

<details>
<summary>Full component list (2026-07-27)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 151.0.7922.47 | nightly tools |
| `chromedriver` | 151.0.7922.47 | nightly tools |
| `claude_code` | 2.1.220 | nightly tools |
| `code_server` | 4.130.0 | nightly tools |
| `ollama` | 0.32.4 | nightly tools |
| `opencode` | 1.18.6 | nightly tools |
| `selenium` | 4.46.0 | nightly tools |
| `uv` | 0.11.32 | nightly tools |
| `vscode` | 1.130.0 | nightly tools |
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

## 2026-07-26

**Build:** 20260313 nightly ✅ 7m 39s · 20260424 nightly ✅ 7m 55s — warnings in build log: 14
**Changed:** `ollama` 0.32.3 → 0.32.4
**Known issues (for the versions in this build):**
- `ollama` 0.32.4 — [release notes](https://github.com/ollama/ollama/releases/tag/v0.32.4) — none listed in release notes

<details>
<summary>Full component list (2026-07-26)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 151.0.7922.47 | nightly tools |
| `chromedriver` | 151.0.7922.47 | nightly tools |
| `claude_code` | 2.1.220 | nightly tools |
| `code_server` | 4.130.0 | nightly tools |
| `ollama` | 0.32.4 | nightly tools |
| `opencode` | 1.18.5 | nightly tools |
| `selenium` | 4.46.0 | nightly tools |
| `uv` | 0.11.32 | nightly tools |
| `vscode` | 1.130.0 | nightly tools |
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

## 2026-07-25

**Build:** 20260313 nightly ✅ 5m 11s · 20260424 nightly ✅ 5m 7s — warnings in build log: 10
**Changed:** `claude_code` 2.1.218 → 2.1.220 · `opencode` 1.18.4 → 1.18.5
**Known issues (for the versions in this build):**
- `claude_code` 2.1.220 — [release notes](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md) — see changelog entry (no known-issues section)
- `opencode` 1.18.5 — [release notes](https://github.com/anomalyco/opencode/releases/tag/v1.18.5) — none listed in release notes

<details>
<summary>Full component list (2026-07-25)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 151.0.7922.47 | nightly tools |
| `chromedriver` | 151.0.7922.47 | nightly tools |
| `claude_code` | 2.1.220 | nightly tools |
| `code_server` | 4.130.0 | nightly tools |
| `ollama` | 0.32.3 | nightly tools |
| `opencode` | 1.18.5 | nightly tools |
| `selenium` | 4.46.0 | nightly tools |
| `uv` | 0.11.32 | nightly tools |
| `vscode` | 1.130.0 | nightly tools |
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

## 2026-07-24

**Build:** 20260313 nightly ✅ 9m 30s · 20260424 nightly ✅ 8m 40s — warnings in build log: 18
**Changed:** `code_server` 4.129.0 → 4.130.0 · `ollama` 0.32.1 → 0.32.3 · `uv` 0.11.31 → 0.11.32
**Known issues (for the versions in this build):**
- `code_server` 4.130.0 — [release notes](https://github.com/coder/code-server/releases/tag/v4.130.0) — none listed in release notes
- `ollama` 0.32.3 — [release notes](https://github.com/ollama/ollama/releases/tag/v0.32.3) — none listed in release notes
- `uv` 0.11.32 — [release notes](https://github.com/astral-sh/uv/releases/tag/0.11.32) — none listed in release notes

<details>
<summary>Full component list (2026-07-24)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 151.0.7922.47 | nightly tools |
| `chromedriver` | 151.0.7922.47 | nightly tools |
| `claude_code` | 2.1.218 | nightly tools |
| `code_server` | 4.130.0 | nightly tools |
| `ollama` | 0.32.3 | nightly tools |
| `opencode` | 1.18.4 | nightly tools |
| `selenium` | 4.46.0 | nightly tools |
| `uv` | 0.11.32 | nightly tools |
| `vscode` | 1.130.0 | nightly tools |
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

## 2026-07-23

**Build:** 20260313 nightly ✅ 10m 53s · 20260424 nightly ✅ 11m 0s — warnings in build log: 18
**Changed:** `chrome` 151.0.7922.34 → 151.0.7922.47 · `chromedriver` 151.0.7922.34 → 151.0.7922.47 · `claude_code` 2.1.217 → 2.1.218 · `vscode` 1.129.1 → 1.130.0
**Known issues (for the versions in this build):**
- `chrome` 151.0.7922.47 — [release notes](https://chromereleases.googleblog.com/search/label/Stable%20updates) — see Chrome stable release blog
- `chromedriver` 151.0.7922.47 — [release notes](https://chromereleases.googleblog.com/search/label/Stable%20updates) — see Chrome stable release blog
- `claude_code` 2.1.218 — [release notes](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md) — see changelog entry (no known-issues section)
- `vscode` 1.130.0 — [release notes](https://code.visualstudio.com/updates/v1_130) — see VS Code release notes

<details>
<summary>Full component list (2026-07-23)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 151.0.7922.47 | nightly tools |
| `chromedriver` | 151.0.7922.47 | nightly tools |
| `claude_code` | 2.1.218 | nightly tools |
| `code_server` | 4.129.0 | nightly tools |
| `ollama` | 0.32.1 | nightly tools |
| `opencode` | 1.18.4 | nightly tools |
| `selenium` | 4.46.0 | nightly tools |
| `uv` | 0.11.31 | nightly tools |
| `vscode` | 1.130.0 | nightly tools |
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

## 2026-07-22

**Build:** 20260313 nightly ✅ 4m 46s · 20260424 nightly ✅ 4m 42s — warnings in build log: 10
**Changed:** `claude_code` 2.1.216 → 2.1.217 · `uv` 0.11.30 → 0.11.31
**Known issues (for the versions in this build):**
- `claude_code` 2.1.217 — [release notes](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md) — see changelog entry (no known-issues section)
- `uv` 0.11.31 — [release notes](https://github.com/astral-sh/uv/releases/tag/0.11.31) — none listed in release notes

<details>
<summary>Full component list (2026-07-22)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 151.0.7922.34 | nightly tools |
| `chromedriver` | 151.0.7922.34 | nightly tools |
| `claude_code` | 2.1.217 | nightly tools |
| `code_server` | 4.129.0 | nightly tools |
| `ollama` | 0.32.1 | nightly tools |
| `opencode` | 1.18.4 | nightly tools |
| `selenium` | 4.46.0 | nightly tools |
| `uv` | 0.11.31 | nightly tools |
| `vscode` | 1.129.1 | nightly tools |
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

## 2026-07-21

**Build:** 20260313 nightly ✅ 4m 48s · 20260424 nightly ✅ 4m 40s — warnings in build log: 10
**Changed:** `claude_code` 2.1.215 → 2.1.216 · `opencode` 1.18.3 → 1.18.4 · `uv` 0.11.29 → 0.11.30
**Known issues (for the versions in this build):**
- `claude_code` 2.1.216 — [release notes](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md) — see changelog entry (no known-issues section)
- `opencode` 1.18.4 — [release notes](https://github.com/anomalyco/opencode/releases/tag/v1.18.4) — none listed in release notes
- `uv` 0.11.30 — [release notes](https://github.com/astral-sh/uv/releases/tag/0.11.30) — none listed in release notes

<details>
<summary>Full component list (2026-07-21)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 151.0.7922.34 | nightly tools |
| `chromedriver` | 151.0.7922.34 | nightly tools |
| `claude_code` | 2.1.216 | nightly tools |
| `code_server` | 4.129.0 | nightly tools |
| `ollama` | 0.32.1 | nightly tools |
| `opencode` | 1.18.4 | nightly tools |
| `selenium` | 4.46.0 | nightly tools |
| `uv` | 0.11.30 | nightly tools |
| `vscode` | 1.129.1 | nightly tools |
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

## 2026-07-19

**Build:** 20260313 nightly ✅ 12m 6s · 20260424 nightly ✅ 12m 21s — warnings in build log: 18
**Changed:** `chrome` 149.0.7827.155 → 151.0.7922.34 · `chromedriver` 149.0.7827.155 → 151.0.7922.34 · `claude_code` 2.1.179 → 2.1.215 · `code_server` 4.124.2 → 4.129.0 · `ollama` 0.30.9 → 0.32.1 · `opencode` 1.17.7 → 1.18.3 · `selenium` 4.45.0 → 4.46.0 · `uv` 0.11.21 → 0.11.29 · `vscode` 1.124.2 → 1.129.1
**Known issues (for the versions in this build):**
- `chrome` 151.0.7922.34 — [release notes](https://chromereleases.googleblog.com/search/label/Stable%20updates) — see Chrome stable release blog
- `chromedriver` 151.0.7922.34 — [release notes](https://chromereleases.googleblog.com/search/label/Stable%20updates) — see Chrome stable release blog
- `claude_code` 2.1.215 — [release notes](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md) — see changelog entry (no known-issues section)
- `code_server` 4.129.0 — [release notes](https://github.com/coder/code-server/releases/tag/v4.129.0) — none listed in release notes
- `ollama` 0.32.1 — [release notes](https://github.com/ollama/ollama/releases/tag/v0.32.1) — none listed in release notes
- `opencode` 1.18.3 — [release notes](https://github.com/anomalyco/opencode/releases/tag/v1.18.3) — none listed in release notes
- `selenium` 4.46.0 — [release notes](https://github.com/SeleniumHQ/selenium/releases/tag/selenium-4.46.0) — none listed in release notes
- `uv` 0.11.29 — [release notes](https://github.com/astral-sh/uv/releases/tag/0.11.29) — none listed in release notes
- `vscode` 1.129.1 — [release notes](https://code.visualstudio.com/updates/v1_129) — see VS Code release notes

<details>
<summary>Full component list (2026-07-19)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 151.0.7922.34 | nightly tools |
| `chromedriver` | 151.0.7922.34 | nightly tools |
| `claude_code` | 2.1.215 | nightly tools |
| `code_server` | 4.129.0 | nightly tools |
| `ollama` | 0.32.1 | nightly tools |
| `opencode` | 1.18.3 | nightly tools |
| `selenium` | 4.46.0 | nightly tools |
| `uv` | 0.11.29 | nightly tools |
| `vscode` | 1.129.1 | nightly tools |
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

## 2026-06-17

**Build:** 20260313 nightly ✅ 8m 17s · 20260424 nightly ✅ 8m 15s — warnings in build log: 8
**Changed:** `chrome` 149.0.7827.115 → 149.0.7827.155 · `chromedriver` 149.0.7827.115 → 149.0.7827.155 · `claude_code` 2.1.178 → 2.1.179 · `code_server` 4.123.0 → 4.124.2 · `ollama` 0.30.8 → 0.30.9
**Known issues (for the versions in this build):**
- `chrome` 149.0.7827.155 — [release notes](https://chromereleases.googleblog.com/search/label/Stable%20updates) — see Chrome stable release blog
- `chromedriver` 149.0.7827.155 — [release notes](https://chromereleases.googleblog.com/search/label/Stable%20updates) — see Chrome stable release blog
- `claude_code` 2.1.179 — [release notes](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md) — see changelog entry (no known-issues section)
- `code_server` 4.124.2 — [release notes](https://github.com/coder/code-server/releases/tag/v4.124.2) — none listed in release notes
- `ollama` 0.30.9 — [release notes](https://github.com/ollama/ollama/releases/tag/v0.30.9) — none listed in release notes

<details>
<summary>Full component list (2026-06-17)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 149.0.7827.155 | nightly tools |
| `chromedriver` | 149.0.7827.155 | nightly tools |
| `claude_code` | 2.1.179 | nightly tools |
| `code_server` | 4.124.2 | nightly tools |
| `ollama` | 0.30.9 | nightly tools |
| `opencode` | 1.17.7 | nightly tools |
| `selenium` | 4.45.0 | nightly tools |
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

## 2026-06-16

**Build:** 20260313 nightly ✅ 11m 34s · 20260424 nightly ✅ 11m 43s — warnings in build log: 8
**Changed:** `claude_code` 2.1.177 → 2.1.178 · `selenium` 4.44.0 → 4.45.0
**Known issues (for the versions in this build):**
- `claude_code` 2.1.178 — [release notes](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md) — see changelog entry (no known-issues section)
- `selenium` 4.45.0 — [release notes](https://github.com/SeleniumHQ/selenium/releases) — release notes not found for this version

<details>
<summary>Full component list (2026-06-16)</summary>

| Component | Version | Scope |
|-----------|---------|-------|
| `chrome` | 149.0.7827.115 | nightly tools |
| `chromedriver` | 149.0.7827.115 | nightly tools |
| `claude_code` | 2.1.178 | nightly tools |
| `code_server` | 4.123.0 | nightly tools |
| `ollama` | 0.30.8 | nightly tools |
| `opencode` | 1.17.7 | nightly tools |
| `selenium` | 4.45.0 | nightly tools |
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


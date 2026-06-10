# QSC Image Components

What's inside the QSC JupyterHub images, per Dockerfile version. Written to be
rendered by an information icon on the JupyterHub spawn page's image
selection, alongside the live nightly versions in
[component-versions.json](component-versions.json).

How to read this file:

- **Pinned at baseline** — versions fixed in the Dockerfile; they change only
  when a new dated Dockerfile version is created.
- **Frozen at baseline build** — installed as "latest" when the baseline image
  was first built, then cached; no explicit pin in the Dockerfile.
- **Updated nightly** — refreshed automatically whenever upstream releases a
  new version. Current versions live in
  [component-versions.json](component-versions.json) (`build_date` says which
  nightly tag they correspond to).

---

## Image: `...-20260424` (CUDA 13.2)

Tag: `queensschoolofcomputingdocker/gpu-jupyter-latest:13.2.1cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260424[-nightly]`

### GPU / ML stack (pinned at baseline)

| Component | Version |
|-----------|---------|
| CUDA (incl. cuDNN runtime) | 13.2.1 |
| Ubuntu | 24.04 |
| Python | 3.12 |
| TensorFlow | 2.20.0 |
| Keras | 3.13.0 |
| PyTorch | 2.11.0 |
| torchvision | 0.26.0 |
| torchaudio | 2.11.0 |
| PyTorch Geometric | pyg_lib, torch_scatter, torch_sparse, torch_cluster, torch_spline_conv |

---

## Image: `...-20260313` (CUDA 13.0)

Tag: `queensschoolofcomputingdocker/gpu-jupyter-latest:13.0.2cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260313[-nightly]`

### GPU / ML stack (pinned at baseline)

| Component | Version |
|-----------|---------|
| CUDA (incl. cuDNN runtime) | 13.0.2 |
| Ubuntu | 24.04 |
| Python | 3.12 |
| TensorFlow | 2.20.0 |
| Keras | 3.13.0 |
| PyTorch | 2.9.1 |
| torchvision | 0.24.1 |
| torchaudio | 2.9.1 |
| PyTorch Geometric | pyg_lib, torch_scatter, torch_sparse, torch_cluster, torch_spline_conv |

---

## Common to both images

### MATLAB (pinned at baseline)

**MATLAB R2024b** with toolboxes: Communications, Signal Processing,
DSP System, Symbolic Math, Statistics and Machine Learning, Parallel
Computing, Antenna, 5G, LTE, Phased Array System, Optimization, Global
Optimization, Mapping. Licensed via the Queen's network license server.

### Jupyter environment

| Component | Version |
|-----------|---------|
| JupyterLab + JupyterHub | frozen at baseline build (jupyter/docker-stacks) |
| Julia (+ IJulia kernel) | frozen at baseline build |
| R (+ IRkernel) | frozen at baseline build |
| jupyterlab-git | 0.51.3 |
| plotly | 5.24.1 |
| ipyleaflet | 0.19.2 |
| ipywidgets | 8.1.5 |
| jupyterlab-spellchecker | 0.8.4 |

### Desktop / remote access (pinned at baseline)

| Component | Version |
|-----------|---------|
| TurboVNC | 3.3 |
| xfce4 desktop | frozen at baseline build |
| GitHub CLI (`gh`) | frozen at baseline build |

### Updated nightly

Live versions for these are in
[component-versions.json](component-versions.json) — they track upstream
releases automatically:

| Component | What it is |
|-----------|------------|
| `chrome` | Google Chrome (stable) |
| `chromedriver` | ChromeDriver, always version-matched to Chrome |
| `selenium` | Selenium (Python) + PyVirtualDisplay |
| `vscode` | Visual Studio Code (desktop) |
| `code_server` | code-server (VS Code in the browser) + ms-python extension |
| `ollama` | Ollama local LLM runtime |
| `opencode` | opencode terminal coding agent |
| `uv` | uv Python package manager |
| `claude_code` | Claude Code CLI |

---

*Maintainers: update the per-image sections when adding a new dated
Dockerfile version (see BUILD-PUSH-QSCIMAGES.md → Adding a New Dockerfile
Version). The nightly table needs no maintenance — it is driven by
`component-versions.json`.*

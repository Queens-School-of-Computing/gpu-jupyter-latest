# QSC Image Components

What's installed in each Lobot image. Select an image on the spawn page to see what tools and libraries you'll have available.

- **Current version numbers** for every component are in [component-versions.json](component-versions.json).
- **What changed and when** is in the [Image Changelog](IMAGE-CHANGELOG.md).

Each image comes in two variants. The **(nightly)** variant is refreshed overnight with the latest developer tools (Chrome, VS Code, code-server, Ollama, Claude Code, opencode, uv, Selenium). The plain variant is frozen as it was built on its date — choose it if you need a stable, unchanging environment.

Cluster GPU nodes run the NVIDIA 580-series driver; the ML stacks in these images are kept within what that driver supports.

---

## CUDA 13.2 · TF 2.20 · Apr 24, 2026

| Spawn page option | DockerHub |
|-------------------|-----------|
| CUDA 13.2 · TF 2.20 · Apr 24, 2026 (nightly) | [view tag](https://hub.docker.com/r/queensschoolofcomputingdocker/gpu-jupyter-latest/tags?name=13.2.1cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260424-nightly) |
| CUDA 13.2 · TF 2.20 · Apr 24, 2026 | [view tag](https://hub.docker.com/r/queensschoolofcomputingdocker/gpu-jupyter-latest/tags?name=13.2.1cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260424) |

Full image names:<br>
<sub><code>queensschoolofcomputingdocker/gpu-jupyter-latest:13.2.1cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260424-nightly</code></sub><br>
<sub><code>queensschoolofcomputingdocker/gpu-jupyter-latest:13.2.1cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260424</code></sub>

### GPU & Machine Learning

- CUDA (incl. cuDNN runtime) on Ubuntu
- Python
- TensorFlow + Keras
- PyTorch with torchvision and torchaudio
- PyTorch Geometric (pyg_lib, torch_scatter, torch_sparse, torch_cluster, torch_spline_conv)

---

## CUDA 13.0 · TF 2.20 · Mar 13, 2026

| Spawn page option | DockerHub |
|-------------------|-----------|
| CUDA 13.0 · TF 2.20 · Mar 13, 2026 (nightly) | [view tag](https://hub.docker.com/r/queensschoolofcomputingdocker/gpu-jupyter-latest/tags?name=13.0.2cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260313-nightly) |
| CUDA 13.0 · TF 2.20 · Mar 13, 2026 | [view tag](https://hub.docker.com/r/queensschoolofcomputingdocker/gpu-jupyter-latest/tags?name=13.0.2cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260313) |

Full image names:<br>
<sub><code>queensschoolofcomputingdocker/gpu-jupyter-latest:13.0.2cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260313-nightly</code></sub><br>
<sub><code>queensschoolofcomputingdocker/gpu-jupyter-latest:13.0.2cudnn-2.20.0tf-matlab-ollama-claude-qsc-u24.04-20260313</code></sub>

### GPU & Machine Learning

- CUDA (incl. cuDNN runtime) on Ubuntu
- Python
- TensorFlow + Keras
- PyTorch with torchvision and torchaudio
- PyTorch Geometric (pyg_lib, torch_scatter, torch_sparse, torch_cluster, torch_spline_conv)

---

## Common to both images

### MATLAB (pinned at baseline)

**MATLAB** with toolboxes: Communications, Signal Processing,
DSP System, Symbolic Math, Statistics and Machine Learning, Parallel
Computing, Antenna, 5G, LTE, Phased Array System, Optimization, Global
Optimization, Mapping. Licensed via the Queen's network license server.

### Jupyter & Notebooks

- JupyterLab + JupyterHub
- Julia
- R
- jupyterlab-git (Git integration)
- plotly (interactive plots)
- ipyleaflet (interactive maps)
- ipywidgets (interactive notebook widgets)
- jupyterlab-spellchecker

### Desktop & Remote Access

- TurboVNC remote desktop
- xfce4 desktop
- GitHub CLI

### Automatically Updated Tools

These are kept up-to-date automatically (refreshed in the nightly variants):

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

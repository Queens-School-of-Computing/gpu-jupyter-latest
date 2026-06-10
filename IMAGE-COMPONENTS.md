# QSC Image Components

What's installed in each Lobot image. Select an image on the spawn page to see what tools and libraries you'll have available.

---

## CUDA 13.2 Image (April 24, 2026)

### GPU & Machine Learning

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

## CUDA 13.0 Image (March 13, 2026)

### GPU & Machine Learning

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

### Jupyter & Notebooks

| Component | Version |
|-----------|---------|
| JupyterLab + JupyterHub | Latest stable |
| Julia | Latest stable |
| R | Latest stable |
| jupyterlab-git | 0.51.3 |
| plotly | 5.24.1 |
| ipyleaflet | 0.19.2 |
| ipywidgets | 8.1.5 |
| jupyterlab-spellchecker | 0.8.4 |

### Desktop & Remote Access

| Component | Version |
|-----------|---------|
| TurboVNC | 3.3 |
| xfce4 desktop | Latest stable |
| GitHub CLI | Latest stable |

### Automatically Updated Tools

These are kept up-to-date automatically:

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


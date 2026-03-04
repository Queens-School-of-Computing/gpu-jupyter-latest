# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

GPU-Jupyter is a Docker image generator that merges NVIDIA CUDA base images with Jupyter docker-stacks to produce GPU-capable JupyterLab environments. The final Docker image is assembled by `generate-Dockerfile.sh`, which concatenates multiple Dockerfile fragments into `.build/Dockerfile`. **Never edit `.build/Dockerfile` directly** — it is regenerated on every script run.

Current versions: CUDA 12.6.3, cuDNN runtime, Ubuntu 24.04, TensorFlow 2.18.0, PyTorch 2.6.0 (cu126).

## Key Commands

### Generate the Dockerfile

```bash
# Full image (Python + Julia + R + useful packages)
./generate-Dockerfile.sh

# Python-only (no Julia/R, includes useful packages)
./generate-Dockerfile.sh --python-only

# Slim (no Julia/R, no useful packages)
./generate-Dockerfile.sh --slim

# Use latest docker-stacks commit (may cause conflicts)
./generate-Dockerfile.sh --commit latest

# Set a password
./generate-Dockerfile.sh --password mypassword
```

### Build and Run

```bash
# Build image (after generating Dockerfile)
docker build -t gpu-jupyter .build/

# Run container (GPU, port 8848 → 8888, data volume mounted)
docker run --gpus all -d -it -p 8848:8888 \
  -v $(pwd)/data:/home/jovyan/work \
  -e GRANT_SUDO=yes -e JUPYTER_ENABLE_LAB=yes \
  -e NB_UID="$(id -u)" -e NB_GID="$(id -g)" \
  --user root --restart always --name gpu-jupyter_1 gpu-jupyter

# Get the Jupyter token
docker exec -it gpu-jupyter_1 jupyter server list
```

### Docker Compose

```bash
docker-compose up --build -d   # build and start
docker-compose ps              # check status
docker-compose logs -f         # view logs
docker-compose down            # stop
```

### Docker Swarm Deployment

```bash
./add-to-swarm.sh -p 8848 -n <docker-network> -r 5001
docker service ps gpu_gpu-jupyter
```

### Build and Push All Variants (requires version branch)

```bash
# Only works on branches named like: v1.7_cuda-12.2_ubuntu-22.04
./build_push_all.sh
```

## Architecture

```
generate-Dockerfile.sh          # Main build orchestrator
custom/
  header.Dockerfile             # FROM nvidia/cuda:... base + apt-utils
  gpulibs.Dockerfile            # TensorFlow, PyTorch, cuda-nvcc
  usefulpackages.Dockerfile     # graphviz, pytest, JupyterLab extensions
.build/
  Dockerfile                    # Generated — do not edit
  docker-stacks/                # Git submodule (jupyter/docker-stacks)
  *.sh, *.py, *.json            # Support files copied during generation
docker-compose.yml              # Local deployment config
add-to-swarm.sh                 # Docker Swarm deployment
data/                           # Mounted into container at /home/jovyan/work
```

### How `generate-Dockerfile.sh` Works

The script:
1. Clones (or resets) the `docker-stacks` submodule in `.build/docker-stacks` to a pinned commit (`HEAD_COMMIT` variable)
2. Concatenates in order: `custom/header.Dockerfile` → docker-stacks-foundation → base-notebook → minimal-notebook → scipy-notebook → (optionally) datascience-notebook → `custom/gpulibs.Dockerfile` → (optionally) `custom/usefulpackages.Dockerfile`
3. Appends `JUPYTER_TOKEN` support and optional password config
4. Copies support files (startup scripts, health checks, etc.) into `.build/`

### Customisation Points

| What to change | Where |
|---|---|
| CUDA/Ubuntu base version | `custom/header.Dockerfile` — change the `FROM` line |
| GPU libraries (TF, PyTorch versions) | `custom/gpulibs.Dockerfile` |
| Extra Python/JupyterLab packages | `custom/usefulpackages.Dockerfile` |
| docker-stacks pinned commit | `HEAD_COMMIT` variable in `generate-Dockerfile.sh` |
| Static Jupyter token | Set `JUPYTER_TOKEN` env var at runtime |
| Password | `./generate-Dockerfile.sh --password <pw>` |

### Branch / Tag Convention

Release branches follow the pattern: `v{version}_cuda-{cuda-version}_ubuntu-{ubuntu-version}`
Example: `v1.7_cuda-12.6_ubuntu-24.04`

### Port Mapping

The container exposes port `8888`; it is mapped to `8848` on the host by default. JupyterLab is available at [http://localhost:8848](http://localhost:8848).

### MATLAB (Internal)

`.build/` contains MATLAB Package Manager (`mpm`) support files for internal use. The MATLAB license file (`network.lic`) must be present in `.build/`. Tests for MATLAB are in `.build/tests/`.

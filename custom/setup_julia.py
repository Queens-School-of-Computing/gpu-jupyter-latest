#!/usr/bin/env python3
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
#
# Patched by QSC: pins Julia to a specific version instead of fetching latest.
# Change JULIA_VERSION below when you want to upgrade.

import logging
import os
import platform
import shutil
import subprocess
from pathlib import Path

LOGGER = logging.getLogger(__name__)

# Pinned Julia version — update this to upgrade
JULIA_VERSION = "1.10.5"


def unify_aarch64(arch: str) -> str:
    """Renames arm64->aarch64 to support local builds on aarch64 Macs"""
    return {"arm64": "aarch64"}.get(arch, arch)


def get_pinned_julia_url() -> tuple[str, str]:
    """Returns the download URL for the pinned Julia version."""
    arch = unify_aarch64(platform.machine())
    # Julia uses x64/aarch64 in its URL path
    short_arch = {"x86_64": "x64", "aarch64": "aarch64"}.get(arch, arch)
    major_minor = ".".join(JULIA_VERSION.split(".")[:2])
    url = (
        f"https://julialang-s3.julialang.org/bin/linux/{short_arch}/"
        f"{major_minor}/julia-{JULIA_VERSION}-linux-{arch}.tar.gz"
    )
    LOGGER.info(f"Pinned Julia version: {JULIA_VERSION}, url: {url}")
    return url, JULIA_VERSION


def download_julia(julia_url: str) -> None:
    """Downloads and unpacks Julia to /opt/"""
    LOGGER.info("Downloading and unpacking Julia")
    tmp_file = Path("/tmp/julia.tar.gz")
    subprocess.check_call(
        ["curl", "--progress-bar", "--location", "--output", tmp_file, julia_url]
    )
    shutil.unpack_archive(tmp_file, "/opt/")
    tmp_file.unlink()


def configure_julia(julia_version: str) -> None:
    """Creates /usr/local/bin/julia symlink, configures conda lib path, creates JULIA_PKGDIR"""
    LOGGER.info("Configuring Julia")
    subprocess.check_call(
        ["ln", "-fs", f"/opt/julia-{julia_version}/bin/julia", "/usr/local/bin/julia"]
    )
    Path("/etc/julia").mkdir()
    Path("/etc/julia/juliarc.jl").write_text(
        f'push!(Libdl.DL_LOAD_PATH, "{os.environ["CONDA_DIR"]}/lib")\n'
    )
    JULIA_PKGDIR = Path(os.environ["JULIA_PKGDIR"])
    JULIA_PKGDIR.mkdir()
    subprocess.check_call(["chown", os.environ["NB_USER"], JULIA_PKGDIR])
    subprocess.check_call(["fix-permissions", JULIA_PKGDIR])


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    julia_url, julia_version = get_pinned_julia_url()
    download_julia(julia_url=julia_url)
    configure_julia(julia_version=julia_version)

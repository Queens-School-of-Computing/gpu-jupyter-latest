############################################################################
############################ QSC packages ###############################
############################################################################

LABEL authors="Aaron Visser"

USER root


USER $NB_UID
RUN pip install --root-user-action ignore --no-cache-dir jupyterhub jupyterlab jupyter-server
RUN pip install --root-user-action ignore --no-cache-dir jupyter-server-proxy jupyter-vscode-proxy lief lckr_jupyterlab_variableinspector \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

USER root
RUN curl -fsSL https://code-server.dev/install.sh | sh
RUN code-server --install-extension ms-python.python

# ssh and others
RUN apt-get update \
  && apt-get install -y openssh-client vim tmux upx-ucl file libmagic-dev tree p7zip-full

USER $NB_UID


## not running for some reason
RUN mamba install --quiet --yes \
  nb_conda_kernels


# # ida:
# RUN dpkg --add-architecture i386 && apt-get -y update
# RUN apt-get -y install python3-pip

# RUN mkdir /ida
# RUN mkdir /ida_install
# COPY ida.run /ida_install
# RUN chmod +x /ida_install/ida.run
# ARG IDA_PASSWORD
# RUN printf "\n\n\n\n\n\ny\n\ny\ny\n" | /ida_install/ida.run --installpassword $IDA_PASSWORD --prefix /ida
# USER $NB_UID
# ENV PATH "$PATH:/ida"
# RUN mkdir ~/.idapro
# RUN touch ~/.idapro/ida.reg
# RUN /usr/bin/python3 -m pip install --upgrade pip
# RUN /usr/bin/pip3 install git+https://github.com/L1NNA/JARV1S-Ghidra@master autopep8 pylint

USER root


# Chrome-driver
RUN curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install -y ./google-chrome-stable_current_amd64.deb
RUN rm google-chrome-stable_current_amd64.deb


RUN pip install --root-user-action ignore PyVirtualDisplay selenium \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

RUN mkdir /chromedriver
# ChromeDriver major version must match the Chrome installed above
RUN CHROME_MAJOR=$(google-chrome --version | grep -oE '[0-9]+' | head -1) && DRIVER_VERSION=$(wget -qO- "https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_${CHROME_MAJOR}") && wget "https://storage.googleapis.com/chrome-for-testing-public/${DRIVER_VERSION}/linux64/chromedriver-linux64.zip" && unzip chromedriver-linux64.zip && cp chromedriver-linux64/chromedriver /chromedriver/
RUN rm chromedriver-linux64.zip
RUN rm -r chromedriver-linux64
ENV PATH "$PATH:/chromedriver"

# install jvd package:
# RUN /usr/bin/python3 -m pip install git+https://github.com/L1NNA/JARV1S-Ghidra@master
# RUN python -m pip install git+https://github.com/L1NNA/JARV1S-Ghidra@master autopep8 pylint

# RDT:
USER root

# AV - added power-manager to be able to remove the screensaver (set presentation-mode)
#RUN apt-get -y update \
RUN apt-get install -y dbus-x11 \
  xfce4 \
  xfce4-panel \
  xfce4-session \
  xfce4-settings \
  xorg

# AV - specifically remove and purge xfce4-screensaver to prevent screen locking.
RUN apt-get remove -y -q --purge xfce4-screensaver

# Remove light-locker to prevent screen lock
RUN wget 'https://github.com/TurboVNC/turbovnc/releases/download/3.3beta1/turbovnc_3.2.90_amd64.deb' -O turbovnc_3.2.90_amd64.deb && \
  apt-get install -y -q ./turbovnc_3.2.90_amd64.deb && \
  apt-get remove -y -q --purge light-locker && \
  rm ./turbovnc_3.2.90_amd64.deb && \
  ln -s /opt/TurboVNC/bin/* /usr/local/bin/


# AV Sept 26 2024 - install full vscode
USER root

#https://update.code.visualstudio.com/1.93.1/linux-deb-arm64/stable
#RUN wget 'https://update.code.visualstudio.com/1.103.3/linux-deb-x64/stable' -O code.deb && \
RUN wget 'https://update.code.visualstudio.com/latest/linux-deb-x64/stable' -O code.deb && \
    dpkg -i code.deb && \
    rm code.deb

# apt-get may result in root-owned directories/files under $HOME
RUN chown -R $NB_UID:$NB_GID $HOME

#USER root
USER $NB_UID

# conda not working?
RUN mamba install -y -c conda-forge websockify
RUN pip install --root-user-action ignore  git+https://github.com/L1NNA/jupyter-remote-desktop-proxy@main \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

USER root

RUN apt-get -y install gtk2-engines-murrine gtk2-engines-pixbuf sassc optipng inkscape ibglib2.0-dev-bin libglib2.0-dev libxml2-utils

#USER root
USER $NB_UID
# torch:
RUN pip install --root-user-action ignore  torch_geometric \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

RUN pip install --root-user-action ignore  pyg_lib torch_scatter torch_sparse torch_cluster torch_spline_conv -f https://data.pyg.org/whl/torch-2.6.0+cu126.html \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

#instell resource manager
RUN pip install pip jupyter-resource-usage \
&& fix-permissions "${CONDA_DIR}" \
&& fix-permissions "/home/${NB_USER}"

USER root
#muLab Requests July 9 2025
RUN curl -fsSL https://ollama.com/install.sh | sh
RUN apt-get install -y btop

#miblab Ryan Zhou Requests Oct 2 2025
RUN apt-get install -y npm
RUN npm install -g @anthropic-ai/claude-code

#miblab Ryan Zhou Requests Feb 5 2026
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
RUN (type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
    && sudo mkdir -p -m 755 /etc/apt/keyrings \
    && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && sudo mkdir -p -m 755 /etc/apt/sources.list.d \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y

# AV Feb 15 2026 - enable jupyter hub collaboration feature
RUN mamba install -y -c conda-forge jupyter-collaboration && mamba clean -afy

# other dev tools
RUN apt-get install -y nvtop
RUN apt-get install -y ncdu
RUN apt-get install  -y -q  libtool autoconf automake
RUN apt-get install  -y -q  software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get install -y -q libpython3.12-dev
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update
RUN apt-get -y -q install gcc-9
RUN apt autoremove -y


# Clean installation
ENV NODE_OPTIONS=
RUN update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/google-chrome 500
RUN update-alternatives --set x-www-browser /usr/bin/google-chrome
RUN mamba clean --all -f -y && \
  fix-permissions $CONDA_DIR && \
  fix-permissions /home/$NB_USER

RUN fix-permissions /home/$NB_USER

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID

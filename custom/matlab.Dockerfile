#################################
############## QSC Matlab ########
#################################
# To specify which MATLAB release to install in the container, edit the value of the MATLAB_RELEASE argument.
# Use uppercase to specify the release, for example: ARG MATLAB_RELEASE=R2021b
ARG MATLAB_RELEASE=R2024b

# Specify the list of products to install into MATLAB.
#ARG MATLAB_PRODUCT_LIST="MATLAB"
# toolboxes specified by gands lab
ARG MATLAB_PRODUCT_LIST="MATLAB Communications_Toolbox Signal_Processing_Toolbox DSP_System_Toolbox Symbolic_Math_Toolbox Statistics_and_Machine_Learning_Toolbox Parallel_Computing_Toolbox Antenna_Toolbox 5G_Toolbox LTE_Toolbox Phased_Array_System_Toolbox Optimization_Toolbox Global_Optimization_Toolbox Mapping_Toolbox"


# Specify MATLAB Install Location.
ARG MATLAB_INSTALL_LOCATION="/opt/matlab/${MATLAB_RELEASE}"

# Specify license server information using the format: port@hostname
ARG LICENSE_SERVER

# When you start the build stage, this Dockerfile by default uses the Ubuntu-based matlab-deps image.
# To check the available matlab-deps images, see: https://hub.docker.com/r/mathworks/matlab-deps
#FROM mathworks/matlab-deps:${MATLAB_RELEASE}

# Declare build arguments to use at the current build stage.
ARG MATLAB_RELEASE
ARG MATLAB_PRODUCT_LIST
ARG MATLAB_INSTALL_LOCATION
ARG LICENSE_SERVER

USER root

COPY base-matlabdependencies.txt /tmp/base-matlabdependencies.txt

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install --no-install-recommends -y `cat /tmp/base-matlabdependencies.txt` \
    && apt-get clean && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN [ -d /usr/share/X11/xkb ] || mkdir -p /usr/share/X11/xkb




# Install mpm dependencies.
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install --no-install-recommends --yes \
    wget \
    ca-certificates \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

USER root

# Add "matlab" user and grant sudo permission.
#RUN adduser --shell /bin/bash --disabled-password --gecos "" matlab \
#    && echo "matlab ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/matlab \
#    && chmod 0440 /etc/sudoers.d/matlab

# Set user and work directory.
#USER matlab
#WORKDIR /home/matlab

USER root
RUN mkdir -p "${MATLAB_INSTALL_LOCATION}" \
    && chown "${NB_USER}" "${MATLAB_INSTALL_LOCATION}"

USER $NB_UID
# Run mpm to install MATLAB in the target location and delete the mpm installation afterwards.
# If mpm fails to install successfully, then print the logfile in the terminal, otherwise clean up.
# Pass in $HOME variable to install support packages into the user's HOME folder.
RUN wget -q https://www.mathworks.com/mpm/glnxa64/mpm \
    && chmod +x mpm \
    && mkdir -p "${MATLAB_INSTALL_LOCATION}" \
    && chown "${NB_USER}" "${MATLAB_INSTALL_LOCATION}"  \
    && HOME=${HOME} ./mpm install \
    --release=${MATLAB_RELEASE} \
    --destination=${MATLAB_INSTALL_LOCATION} \
    --products ${MATLAB_PRODUCT_LIST} \
    || (echo "MPM Installation Failure. See below for more information:" && cat /tmp/mathworks_root.log && false) \
    && rm -rf mpm /tmp/mathworks_root.log

USER root
RUN ln -s ${MATLAB_INSTALL_LOCATION}/bin/matlab /usr/local/bin/matlab

RUN apt-get update \
  && apt install -y xvfb

USER ${NB_UID}
RUN pip install --root-user-action ignore jupyter-matlab-proxy

USER root

# Note: Uncomment one of the following two ways to configure the license server.

# Option 1. Specify the host and port of the machine that serves the network licenses
# if you want to store the license information in an environment variable. This
# is the preferred option. You can either use a build variable, like this:
# --build-arg LICENSE_SERVER=27000@MyServerName or you can specify the license server
# directly using: ENV MLM_LICENSE_FILE=27000@flexlm-server-name
#ENV MLM_LICENSE_FILE=$LICENSE_SERVER

# Option 2. Alternatively, you can put a license file into the container.
# Enter the details of the license server in this file and uncomment the following line.
COPY network.lic ${MATLAB_INSTALL_LOCATION}/licenses/

# The following environment variables allow MathWorks to understand how this MathWorks
# product (MATLAB Dockerfile) is being used. This information helps us make MATLAB even better.
# Your content, and information about the content within your files, is not shared with MathWorks.
# To opt out of this service, delete the environment variables defined in the following line.
# To learn more, see the Help Make MATLAB Even Better section in the accompanying README:
# https://github.com/mathworks-ref-arch/matlab-dockerfile#help-make-matlab-even-better
ENV MW_DDUX_FORCE_ENABLE=true MW_CONTEXT_TAGS=MATLAB:DOCKERFILE:V1

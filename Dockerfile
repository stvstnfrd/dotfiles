# Build a new sandbox
ARG DOCKER_OS_ID
ARG DOCKER_OS_VERSION
FROM $DOCKER_OS_ID:$DOCKER_OS_VERSION

# Install some base requirements, as few as possible
RUN apt-get update --yes
RUN apt-get install --yes curl build-essential git sudo

# Create a test user
ENV USER=dev
ENV HOME=/home/${USER}
RUN useradd -m --shell /bin/bash --groups sudo ${USER}
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN chown -R ${USER} ${HOME}
ENV EUID=1000
USER ${USER}

# Ensure everything is done headless
ENV DEBIAN_FRONTEND=noninteractive
ENV NIX_DAEMON=--no-daemon

# Create our project directory
RUN mkdir -p ${HOME}/.config/dotfiles
WORKDIR ${HOME}/.config/dotfiles

# Re-create `make from-scratch`, but omit `make update`, since the install is fresh.
# Re-create `make system`, step-by-step, to improve caching
COPY --chown=dev .requirements/system.apt.mk .requirements/
RUN sudo make -f .requirements/system.apt.mk system.apt
COPY --chown=dev .requirements/system.brew.mk .requirements/
RUN make -f .requirements/system.brew.mk system.brew
COPY --chown=dev .requirements/system.nix.mk .requirements/
COPY --chown=dev nix/.config/nixpkgs/config.nix nix/.config/nixpkgs/config.nix
RUN make -f .requirements/system.nix.mk system.nix
COPY --chown=dev .requirements/system.pip.mk .requirements/
RUN make -f .requirements/system.pip.mk system.pip
COPY --chown=dev . .
# This is the rest of `make from-scratch`.
RUN make backup
RUN make install
RUN make configure.harden
RUN make configure.hardware

CMD ["bash", "--login"]

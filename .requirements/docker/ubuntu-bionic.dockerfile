# This file was created automatically by: .requirements/docker.mk
# Create a base functioning system
FROM ubuntu:bionic
RUN apt-get update --yes \
&& apt-get install --yes make sudo

# Create a test user
ENV USER=dev
ENV HOME=/home/${USER}
ENV PATH=${HOME}/.nix-profile/bin/:${PATH}
ENV PATH=${HOME}/.local/bin:${PATH}
RUN useradd -m --shell /bin/bash ${USER}
RUN adduser ${USER} sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN chown -R ${USER} ${HOME}
ENV EUID=1000
USER ${USER}
RUN mkdir -p ${HOME}/.config/dotfiles
WORKDIR ${HOME}/.config/dotfiles

# From here on, we're mimicking a normal, user-level install.
# This replicates the behavior of:
#     make system.{apt,nix,pip} backup install configure.harden
COPY Makefile ./

# Install apt pacakges
COPY --chown=dev .requirements/apt.mk .requirements/
COPY --chown=dev .requirements/deb .requirements/deb
RUN echo 'debconf debconf/frontend select Noninteractive' \
| sudo debconf-set-selections \
&& make system.apt ALL_DEB=

# Install docker packages
COPY --chown=dev .requirements/system.mk .requirements/
RUN make system.docker

# Install nix packages
COPY --chown=dev .requirements/nix.mk .requirements/
RUN make system.nix.bootstrap
COPY --chown=dev .requirements/config.nix ${HOME}/.config/nixpkgs/
RUN make system.nix

# Install python packages
COPY --chown=dev .requirements/pip.mk .requirements/
COPY --chown=dev .requirements/pip.txt .requirements/
RUN make system.pip

# Backup existing configuration
COPY --chown=dev .requirements/install.mk .requirements/
RUN make backup

# Install stow packages
COPY --chown=dev . .
RUN make install

# Configure the system, post-install
RUN make configure.harden

# RUN sudo usermod --groups '' ${USER}
# WORKDIR ${HOME}
CMD ["bash", "--login"]

FROM debian:latest

# We recreate `make system.apt` here,
# to avoid copying over the Makefile this early;
# this improves cache-hits w/ layering.
# Also, `make` isn't even installed yet...
COPY .requirements/apt.txt .requirements/apt.txt
RUN apt update -y && \
    apt install -y $(cat .requirements/apt.txt)

# Create a test user
ENV USER=dev
ENV HOME=/home/${USER}
ENV PATH=${HOME}/.nix-profile/bin/:${PATH}
ENV PATH=${HOME}/.local/bin:${PATH}
RUN useradd -m --shell /bin/bash ${USER}
# RUN adduser --disabled-password --gecos '' ${USER}
RUN adduser ${USER} sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN chown -R ${USER} ${HOME}
ENV EUID=1000
USER ${USER}

RUN mkdir -p ${HOME}/.config/dotfiles
WORKDIR ${HOME}/.config/dotfiles

# Install nix packages
COPY --chown=dev Makefile.system.nix.mk ./
COPY --chown=dev .requirements/nix.txt .requirements/nix.txt
RUN make -f Makefile.system.nix.mk system.nix

# Install python packages
COPY --chown=dev Makefile.system.pip.mk ./
COPY --chown=dev .requirements/pip.txt .requirements/pip.txt
RUN make -f Makefile.system.pip.mk system.pip

# Backup existing configuration
COPY --chown=dev Makefile.install.mk ./
RUN make -f Makefile.install.mk backup

# Install stow packages
COPY --chown=dev . .
RUN make install

RUN sudo usermod --groups '' ${USER}
CMD ["bash", "--login"]

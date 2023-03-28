FROM debian:bullseye

RUN apt-get update && apt-get install --yes sudo
ADD https://raw.githubusercontent.com/stvstnfrd/its-package/master/dist/debian/Bootstrap.sh /tmp/bootstrap.sh
RUN . /tmp/bootstrap.sh
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes its-package its-package-dev its-package-gui

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
COPY --chown=dev .requirements/nix.mk .requirements/
COPY --chown=dev .requirements/nix.txt .requirements/
RUN make -f .requirements/nix.mk system.nix

# Install python packages
COPY --chown=dev .requirements/pip.mk .requirements/
COPY --chown=dev .requirements/pip.txt .requirements/
RUN make -f .requirements/pip.mk system.pip

# Backup existing configuration
COPY --chown=dev .requirements/install.mk .requirements/
RUN make -f .requirements/install.mk backup

# Install stow packages
COPY --chown=dev . .
RUN make install

RUN sudo usermod --groups '' ${USER}
CMD ["bash", "--login"]

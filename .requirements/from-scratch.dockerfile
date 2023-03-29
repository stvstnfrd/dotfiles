# Build it all from scratch
ARG DOCKER_OS_ID
ARG DOCKER_OS_VERSION
FROM $DOCKER_OS_ID:$DOCKER_OS_VERSION

# Install some base requirements, as few as possible
RUN apt-get update --yes
RUN apt-get install --yes sudo

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

# Mimic a user pulling down the file, ala "curl URL | sh"
COPY --chown=dev .requirements/bootstrap.sh /tmp/bootstrap.sh
RUN sh /tmp/bootstrap.sh

CMD ["bash", "--login"]

FROM ubuntu:focal

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

ENV DEBIAN_FRONTEND=noninteractive
ENV NIX_DAEMON=--no-daemon
COPY --chown=dev .requirements/bootstrap.sh /tmp/bootstrap.sh
RUN sh /tmp/bootstrap.sh

CMD ["bash", "--login"]

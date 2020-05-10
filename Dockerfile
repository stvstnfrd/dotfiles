FROM debian:latest
ENV PATH=/root/.nix-profile/bin/:${PATH}
ENV PATH=/root/.local/bin:${PATH}
ENV USER=root
RUN mkdir -p /root/.config/dotfiles
WORKDIR /root/.config/dotfiles
RUN apt update -y \
    && apt install -y build-essential
ADD Makefile ./
ADD .requirements/apt.txt .requirements/apt.txt
RUN make system.apt
ADD .requirements/nix.txt .requirements/nix.txt
RUN make system.nix
ADD .requirements/pip.txt .requirements/pip.txt
RUN make system.pip
RUN make backup
ADD . .
RUN make install
CMD ["bash", "--login"]

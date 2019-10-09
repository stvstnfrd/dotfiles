FROM debian:latest
RUN apt update -y \
    && apt upgrade -y \
    && apt install -y sudo curl xz-utils \
;
ADD https://nixos.org/nix/install /tmp/install.nix
RUN mkdir -m 0755 /nix && chown root /nix
RUN groupadd -r nixbld
RUN for n in $(seq 1 10); do \
        useradd -c "Nix build user $n" \
            -d /var/empty -g nixbld -G nixbld -M -N -r -s "$(which nologin)" \
        nixbld$n; done
RUN sudo sh /tmp/install.nix
RUN . /root/.nix-profile/etc/profile.d/nix.sh
ENV PATH=/root/.local/bin:/root/.nix-profile/bin/:${PATH}
RUN nix-env -iA nixpkgs.gitMinimal nixpkgs.gnumake
RUN mkdir -p /root/.config/dotfiles
WORKDIR /root/.config/dotfiles
COPY .requirements/nix.txt .requirements/nix.txt
RUN xargs nix-env -iA < .requirements/nix.txt
COPY .requirements/apt.txt .requirements/apt.txt
RUN xargs apt install -y < .requirements/apt.txt
ADD https://bootstrap.pypa.io/get-pip.py /tmp/get-pip.py
RUN python /tmp/get-pip.py --user
COPY .requirements/pip.txt .requirements/pip.txt
RUN xargs pip install --user < .requirements/pip.txt
COPY Makefile ./Makefile
RUN make system
RUN mkdir .backup
RUN mv -f ${HOME}/.bashrc ${HOME}/.bash_profile ${HOME}/.bash_history ${HOME}/.bash_logout ${HOME}/.profile .backup/ || true
ADD . .
RUN make install
CMD ["bash", "--login"]

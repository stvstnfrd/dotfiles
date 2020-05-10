#!/bin/sh
if ! which nix-env >/dev/null; then
    curl https://nixos.org/nix/install | sh
    . ${HOME}/.nix-profile/etc/profile.d/nix.sh
fi
nix-env -iA nixpkgs.gitMinimal nixpkgs.gnumake
if [ ! -d ${HOME}/.config/dotfiles ]; then
    git clone \
        https://github.com/stvstnfrd/dotfiles.git \
        ${HOME}/.config/dotfiles
fi
cd ${HOME}/.config/dotfiles
make update
sudo make system.apt
make system.brew
make system.nix
make system.pip
make backup
PATH=${HOME}/.nix-profile/bin:${PATH} make install

echo; echo
echo "Bootstrap complete."

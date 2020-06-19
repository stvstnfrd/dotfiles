#!/bin/sh
if ! command -v nix-env >/dev/null 2>&1; then
    curl https://nixos.org/nix/install | sh
    # shellcheck disable=SC1090
    . "${HOME}/.nix-profile/etc/profile.d/nix.sh"
fi
nix-env -iA nixpkgs.gitMinimal nixpkgs.gnumake
if [ ! -d "${HOME}/.config/dotfiles" ]; then
    git clone \
        https://github.com/stvstnfrd/dotfiles.git \
        "${HOME}/.config/dotfiles"
fi
cd "${HOME}/.config/dotfiles" || exit 1
make update
sudo make system.apt
make system.brew
make system.nix
make system.pip
make backup
PATH="${HOME}/.nix-profile/bin:${PATH}" make install

echo; echo
echo "Bootstrap complete."

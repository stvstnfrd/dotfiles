#!/bin/sh
set -e
if [ ! -d "${HOME}/.config/dotfiles" ]; then
    git clone \
        https://github.com/stvstnfrd/dotfiles.git \
        "${HOME}/.config/dotfiles"
fi
cd "${HOME}/.config/dotfiles"
export PATH="${HOME}/.nix-profile/bin:/nix/var/nix/profiles/default/bin:${PATH}"
make update
make system
make backup
make install

echo; echo
echo "Bootstrap complete."

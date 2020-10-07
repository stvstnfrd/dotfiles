#!/bin/sh
set -e
if [ ! -d "${HOME}/.config/dotfiles" ]; then
    git clone \
        https://github.com/stvstnfrd/dotfiles.git \
        "${HOME}/.config/dotfiles"
fi
cd "${HOME}/.config/dotfiles"
make update
make system
make backup
PATH="${HOME}/.nix-profile/bin:${PATH}" make install

echo; echo
echo "Bootstrap complete."

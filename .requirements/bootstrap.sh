#!/bin/sh
set -e
if ! command -v make >/dev/null 2>&1; then
    sudo DEBIAN_FRONTEND=noninteractive apt-get install --yes build-essential
fi
if ! command -v git >/dev/null 2>&1; then
    sudo DEBIAN_FRONTEND=noninteractive apt-get install --yes git
fi
if ! command -v curl >/dev/null 2>&1; then
    sudo DEBIAN_FRONTEND=noninteractive apt-get install --yes curl
fi
if [ ! -d "${HOME}/.config/dotfiles" ]; then
    git clone \
        https://github.com/stvstnfrd/dotfiles.git \
        "${HOME}/.config/dotfiles"
    cd "${HOME}/.config/dotfiles"
    git fetch origin
    git checkout -b fix/build origin/fix/build
fi
cd "${HOME}/.config/dotfiles"
export PATH="${HOME}/.nix-profile/bin:/nix/var/nix/profiles/default/bin:${PATH}"
make from-scratch
echo; echo
echo "Bootstrap complete."

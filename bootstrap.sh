#!/bin/sh
set -e
if ! command -v make >/dev/null 2>&1; then
    sudo apt install -y build-essential
fi
if ! command -v git >/dev/null 2>&1; then
    sudo apt install -y git
fi
if [ ! -d "${HOME}/.config/dotfiles" ]; then
    git clone \
        https://github.com/stvstnfrd/dotfiles.git \
        "${HOME}/.config/dotfiles"
fi
cd "${HOME}/.config/dotfiles"
export PATH="${HOME}/.nix-profile/bin:/nix/var/nix/profiles/default/bin:${PATH}"
make update
make system NIX_DAEMON=--daemon
make backup
make install
make configure.harden || true

echo; echo
echo "Bootstrap complete."

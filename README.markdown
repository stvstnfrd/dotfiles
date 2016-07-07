# dotfiles

## Install

```shell
# Install `stow`
brew install stow || sudo apt-get install stow
# Optional: Backup your current dotfiles
# Grab a copy of the source code
git clone https://github.com/stvstnfrd/dotfiles.git ${HOME}/.config/dotfiles
cd ${HOME}/.config/dotfiles
# Grab the latest code and dependencies
make update
# Install to your ${HOME} directory
make install
```

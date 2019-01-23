# dotfiles

## Installation

### virtual machine

```sh
git clone https://github.com/stvstnfrd/dotfiles.git ${HOME}/.config/dotfiles
cd ${HOME}/.config/dotfiles
vagrant up
vagrant ssh
```

### config-only

```sh
git clone https://github.com/stvstnfrd/dotfiles.git ${HOME}/.config/dotfiles
cd ${HOME}/.config/dotfiles
# make help
make install
```

### metal, bootstrap

```sh
curl https://raw.githubusercontent.com/stvstnfrd/dotfiles/master/bootstrap.sh | sh
```
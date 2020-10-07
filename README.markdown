# dotfiles

## Installation

### docker container

```sh
git clone https://github.com/stvstnfrd/dotfiles.git ${HOME}/.config/dotfiles
cd ${HOME}/.config/dotfiles
make docker.{build,bash}
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
# TODO: update this?
curl https://raw.githubusercontent.com/stvstnfrd/dotfiles/master/bootstrap.sh | sh
```

## Overview

### Operating Systems
- Debian, minimal
  - The `Dockerfile` targets Debian minimal, to test general Debian-based flows.
- Ubuntu/Xubuntu
  - I run a mix of Ubuntu and Xubuntu machines.
- OSX
  - The initial structure of this repo was actually laid out while I was
    doing OSX-based development, so it should still be generally compatible.
    That said, I haven't run OSX since early 2020, so...
  - macos

### Package Managers
- apt
- brew
- nix
  - nix-install...

### Environment Managers
- JavaScript
  - nvm
- Python
  - virtualenv
    - pip

### Tools

#### Source Control
- git
  - diff-so-fancy
  - git-hub

#### Text Editors
- vim
  - plugins
    - vim-*

#### Command Line

##### Terminal Management
- screen

##### Navigation
- cd
- grep
- less

##### Utilities
- curl
- neofetch
- pass

- keyboard
- mnemnoic
- vagrant

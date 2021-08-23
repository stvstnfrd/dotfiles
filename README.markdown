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
curl https://raw.githubusercontent.com/stvstnfrd/dotfiles/master/.requirements/bootstrap.sh | sh
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


## Gotchas


### gpg: decryption failed: No secret key

This works as expected:
- `gpg --list-secret-keys`

but this does not:
- `gpg --decrypt ...`
- `pass -c something/inside/password/store`

You may need to restart the GPG Agent [1]:
- `pkill gpg-agent`



`bash: __vte_prompt_command: command not found`


## References
- [1] https://stackoverflow.com/questions/28321712/gpg-decryption-fails-with-no-secret-key-error
- [2] https://medium.com/@chasinglogic/the-definitive-guide-to-password-store-c337a8f023a1
- [3] https://lists.gnupg.org/pipermail/gnupg-users/2017-August/058981.html

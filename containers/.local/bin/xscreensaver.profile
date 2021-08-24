#!/usr/bin/env firejail-shebang
# include default.local
# include globals.local
# include default.profile
private-bin ${HOME}/.local/nix/profile/bin/xscreensaver
private-bin ${HOME}/.local/nix/profile/bin/xscreensaver-demo
private ${HOME}/.config/xscreensaver
whitelist ${HOME}/.local/nix/profile/bin/xscreensaver
whitelist ${HOME}/.local/nix/profile/bin/xscreensaver-demo
read-write ${HOME}/.xscreensaver

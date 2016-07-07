#!/bin/sh
if type brew >/dev/null 2>&1; then
    if [ -s $(brew --prefix)/etc/profile.d/autojump.sh ]; then
        . $(brew --prefix)/etc/profile.d/autojump.sh
    fi
elif [ -s /usr/local/etc/autojump.sh ]; then
    . /usr/local/etc/autojump.sh
fi

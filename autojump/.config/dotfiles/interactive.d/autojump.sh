#!/bin/sh
if [ -n "${debug}" ]; then
    echo 'funk:autojump:interactive'
fi
if [ -e ${HOME}/.local/etc/profile.d/autojump.sh ]; then
    . ${HOME}/.local/etc/profile.d/autojump.sh
fi

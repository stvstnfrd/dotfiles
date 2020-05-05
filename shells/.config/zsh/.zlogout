#!/bin/zsh
if [ -n "${debug}" ]; then
    echo 'funk:zsh:logout'
fi
if [ -s "${HOME}/.config/sh/logout" ]; then
    . "${HOME}/.config/sh/logout"
fi

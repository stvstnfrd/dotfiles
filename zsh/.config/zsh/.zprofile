#!/bin/zsh
if [ -n "${debug}" ]; then
    echo 'funk:zsh:profile'
fi
if [ -s "${HOME}/.profile" ]; then
    . "${HOME}/.profile"
fi

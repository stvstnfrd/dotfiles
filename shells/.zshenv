#!/bin/zsh
if [ -n "${debug}" ]; then
    echo 'funk:zsh:environment'
fi
if [ -d "${HOME}/.config/zsh" ]; then
    export ZDOTDIR="${HOME}/.config/zsh"
fi

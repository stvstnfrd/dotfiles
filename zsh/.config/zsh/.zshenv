#!/bin/zsh
if [ -n "${debug}" ]; then
    echo 'funk:zsh:environment'
fi
if [ -s "${HOME}/.config/sh/environment" ]; then
    . "${HOME}/.config/sh/environment"
fi

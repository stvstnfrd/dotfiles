#!/bin/bash
if [ -n "${debug}" ]; then
    echo 'funk:bash:profile'
fi
if [ -s "${HOME}/.profile" ]; then
    . "${HOME}/.profile"
fi
if [ -s "${HOME}/.config/bash/environment" ]; then
    . "${HOME}/.config/bash/environment"
fi
if [ -n "${PS1}" ]; then
    if [ -s "${HOME}/.bashrc" ]; then
        . "${HOME}/.bashrc"
    fi
fi

#!/bin/zsh
[[ $- == *i* ]] && return
# While login shells will also sort this via `.zlogin`,
# we need to ensure it happens immediately, so that non-login scripts
# have access to the vars
if [ -s "${HOME}/.config/sh/environment" ]; then
    . "${HOME}/.config/sh/environment"
fi
if [ -s "${HOME}/.config/zsh/environment" ]
then
    . "${HOME}/.config/zsh/environment"
fi

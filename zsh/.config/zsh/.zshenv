#!/bin/zsh
# `export debug=1` to trace who sources who
if [ -n "${debug}" ]; then
    echo 'funk:zsh:environment'
    echo $PATH
fi
[[ $- == *i* ]] && return
# While login shells will also sort this via `.zlogin`,
# we need to ensure it happens immediately, so that non-login scripts
# have access to the vars
if [ -s "${HOME}/.config/sh/environment" ]; then
    . "${HOME}/.config/sh/environment"
fi

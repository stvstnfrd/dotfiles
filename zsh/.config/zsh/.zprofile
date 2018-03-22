#!/bin/zsh
# `export debug=1` to trace who sources who
if [ -n "${debug}" ]; then
    echo 'funk:zsh:profile'
fi
# Pull in the default sh/posix login script
if [ -s "${HOME}/.profile" ]; then
    . "${HOME}/.profile"
fi
# Perform any zsh-only login tasks here

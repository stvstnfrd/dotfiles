#!/bin/zsh
if [ -e "${HOME}/.config/sh/interactive" ]; then
    . "${HOME}/.config/sh/interactive"
fi
if [ -e "${HOME}/.config/zsh/interactive" ]
then
    . "${HOME}/.config/zsh/interactive"
fi

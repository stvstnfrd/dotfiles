#!/bin/zsh
if [ -n "${debug}" ]; then
    echo 'funk:autojump:interactive:zsh'
fi
if [ -e ${HOME}/.local/share/autojump/autojump.zsh ]; then
    . ${HOME}/.local/share/autojump/autojump.zsh
fi

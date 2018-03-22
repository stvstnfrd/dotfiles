#!/bin/bash
if [ -n "${debug}" ]; then
    echo 'funk:autojump:interactive:bash'
fi
if [ -e ${HOME}/.local/share/autojump/autojump.bash ]; then
    . ${HOME}/.local/share/autojump/autojump.bash
fi

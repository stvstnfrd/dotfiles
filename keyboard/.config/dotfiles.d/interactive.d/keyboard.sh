#!/bin/sh
set -o vi
export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"
if [ -n "${DISPLAY}" ]
then
    if command -v setxkbmap >/dev/null 2>&1
    then
        setxkbmap -option caps:swapescape
    fi
fi

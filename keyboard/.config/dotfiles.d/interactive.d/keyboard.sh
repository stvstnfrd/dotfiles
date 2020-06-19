#!/bin/sh
set -o vi
export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"
if command -v setxkbmap >/dev/null 2>&1; then
    printf ''
    # setxkbmap -option caps:swapescape
fi

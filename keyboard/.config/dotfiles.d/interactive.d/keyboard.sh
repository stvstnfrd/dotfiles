#!/bin/sh
set -o vi
export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"
if command setxkbmap 2>&1 >/dev/null; then
    printf ''
    # setxkbmap -option caps:swapescape
fi

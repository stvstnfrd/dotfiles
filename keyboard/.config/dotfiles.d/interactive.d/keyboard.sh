#!/bin/sh
set -o vi
if command setxkbmap 2>&1 >/dev/null; then
    printf ''
    # setxkbmap -option caps:swapescape
fi

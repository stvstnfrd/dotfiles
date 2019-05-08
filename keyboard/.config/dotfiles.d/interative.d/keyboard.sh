#!/bin/sh
if which setxkbmap 2>&1 >/dev/null; then
    setxkbmap -option caps:swapescape
fi

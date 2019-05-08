#!/bin/sh
if [ -n "${debug}" ]; then
    echo 'funk:sh:keyboard'
fi
if which setxkbmap 2>&1 >/dev/null; then
    setxkbmap -option caps:swapescape
fi

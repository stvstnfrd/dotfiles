#!/bin/sh
if command -v exa 2>&1 >/dev/null; then
    alias l='exa --git -a --git-ignore --ignore-glob .git'
    alias ll='exa -l --time-style=long-iso --grid --git -a --git-ignore --ignore-glob .git'
    alias lt='exa -l --time-style=long-iso --tree --level=3 --git -a --git-ignore --ignore-glob .git'
else
    alias l='ls -A'
    alias ll='ls -Alh'
    if command -v tree 2>&1 >/dev/null; then
        alias lt='tree -aL 3'
    fi
fi

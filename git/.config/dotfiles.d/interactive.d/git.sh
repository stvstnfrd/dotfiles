#!/bin/sh
# map aliases from git to bash
# foreach git alias 'x', create bash alias 'gx'
if command -v git 2>&1 >/dev/null; then
    for a in $(git var -l | sed -nE 's/^alias\.([^=]*)=.*/\1/p'); do
        alias g${a}="git ${a} "
    done
fi

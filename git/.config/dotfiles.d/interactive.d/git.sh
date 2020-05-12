#!/bin/sh
# map aliases from git to bash
# foreach git alias 'x', create bash alias 'gx'
if command -v git >/dev/null 2>&1; then
    for a in $(git var -l | sed -nE 's/^alias\.([^=]*)=.*/\1/p'); do
        # shellcheck disable=SC2139
        alias "g${a}=git ${a} "
    done
    alias g='git '
fi

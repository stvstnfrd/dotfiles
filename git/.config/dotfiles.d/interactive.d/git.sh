#!/bin/sh
if [ -n "${debug}" ]; then
    echo 'funk:git:interactive'
fi
# map aliases from git to bash
# foreach git alias 'x', create bash alias 'gx'
for a in $(git var -l | sed -nE 's/^alias\.([^=]*)=.*/\1/p'); do
    alias g${a}="git ${a} "
done
# eval $(git config --get-regexp '^alias\.[^ ]+' | \
# 	sed -e 's/^alias\.\([^ ]*\) \([^!].*\)$/alias g\1="git \1";/' \
# 	    -e 's/^alias\.\([^ ]*\) \!\(.*\)$/alias g\1="\2";/')

#!/bin/sh
# map aliases from git to bash
# foreach git alias 'x', create bash alias 'gx'
if [ -n "${debug}" ]; then
    echo 'funk:git:interactive'
fi
eval $(git config --get-regexp '^alias\.[^ ]+' | \
	sed -e 's/^alias\.\([^ ]*\) \([^!].*\)$/alias g\1="git \1";/' \
	    -e 's/^alias\.\([^ ]*\) \!\(.*\)$/alias g\1="\2";/')

#!/bin/sh
if [ -n "${debug}" ]; then
    echo 'funk:screen:environment'
fi
export SCREENRC="${XDG_CONFIG_HOME}/screen/rc"

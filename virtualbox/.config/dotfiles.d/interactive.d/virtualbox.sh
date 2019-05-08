#!/bin/sh
# TODO: move to environment.d?
if [ -n "${debug}" ]; then
    echo 'funk:virtualbox:interactive'
fi
export VBOX_USER_HOME="${XDG_CONFIG_HOME}/virtualbox"

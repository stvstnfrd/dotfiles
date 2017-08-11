#!/bin/sh
if [ -n "${debug}" ]; then
    echo 'funk:virtualbox:environment'
fi
export VBOX_USER_HOME="${XDG_CONFIG_DIR}/virtualbox"

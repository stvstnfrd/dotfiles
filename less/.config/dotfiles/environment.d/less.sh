#!/bin/sh
if [ -n "${debug}" ]; then
    echo 'funk:less:environment'
fi
export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"

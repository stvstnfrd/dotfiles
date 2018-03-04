#!/bin/sh
if [ -n "${debug}" ]; then
    echo 'funk:pip:environment'
fi
export PIP_CONFIG_FILE=${XDG_CONFIG_HOME}/pip/conf
export PIP_LOG_FILE=${XDG_CACHE_HOME}/pip/log
export ZSH_PIP_CACHE_FILE=${XDG_CACHE_HOME}/pip/zsh

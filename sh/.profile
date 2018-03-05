#!/bin/sh
if [ -n "${debug}" ]; then
    echo 'funk:sh:profile'
fi
# Default permissions for new files
# User has read + write
# Group is readonly
# Other get nothing
umask 0037

# Set some basic ENVIRONMENT variables
. "${HOME}/.config/sh/environment"

# Load all of the plugins
__dir_dotfiles_startup="${DFC}/environment.d"
if [ -d "${__dir_dotfiles_startup}" ]; then
    __script_count=$(find "${__dir_dotfiles_startup}/" -name '*.sh' | wc -l | awk '{print $1}')
    if [ "${__script_count}" -gt 0 ]; then
        for plugin in ${__dir_dotfiles_startup}/*.sh; do
            if [ -r "${plugin}" ]; then
                . "${plugin}"
            fi
        done
        unset plugin
    fi
    unset __script_count
fi
unset __dir_dotfiles_startup

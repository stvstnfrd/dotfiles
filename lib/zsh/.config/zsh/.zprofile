#!/bin/zsh
if [ -s "${HOME}/.config/sh/profile" ]; then
    . "${HOME}/.config/sh/profile"
fi

# Load all of the plugins
__dir_dotfiles_startup="${DFC}/etc/profile.d"
if [ -d "${__dir_dotfiles_startup}" ]; then
    __script_count=$(find "${__dir_dotfiles_startup}/" -name '*.zsh' | wc -l | awk '{print $1}')
    if [ "${__script_count}" -gt 0 ]; then
        for plugin in ${__dir_dotfiles_startup}/*.zsh; do
            if [ -r "${plugin}" ]; then
                . "${plugin}"
            fi
        done
        unset plugin
    fi
    unset __script_count
fi
unset __dir_dotfiles_startup

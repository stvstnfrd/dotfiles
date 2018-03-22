#!/bin/zsh
# `export debug=1` to trace who sources who
if [ -n "${debug}" ]; then
    echo 'funk:zsh:environment'
    echo $PATH
fi
[[ $- == *i* ]] && return
# While login shells will also sort this via `.zlogin`,
# we need to ensure it happens immediately, so that non-login scripts
# have access to the vars
if [ -s "${HOME}/.config/sh/environment" ]; then
    . "${HOME}/.config/sh/environment"
fi
__dir_dotfiles_startup="${DFC}/environment.d"
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

#!/bin/zsh
if [ -e "${HOME}/.config/sh/interactive" ]; then
    . "${HOME}/.config/sh/interactive"
fi
export HISTFILE="${XDG_CACHE_HOME}/zsh/history"
export KEYTIMEOUT=1

# Load all of the plugins
__dir_dotfiles_startup="${DFC}/interactive.d"
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

if [ -e "${ZDOTDIR}/completion.zsh" ]; then
    . "${ZDOTDIR}/completion.zsh"
fi

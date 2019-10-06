#!/bin/zsh
# `export debug=1` to trace who sources who
if [ -n "${debug}" ]; then
    echo 'funk:zsh:interactive'
fi
# Perform any interactive zsh-only tasks here
# This can be aliases,
ZSH_COMPDUMP="${HOME}/.cache/zsh/compdump-${SHORT_HOST}-${ZSH_VERSION}"
. "${ZDOTDIR}/.oh-my-zshrc"
. "${HOME}/.config/sh/interactive"

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

if [ -e "${ZDOTDIR}/completion.d/pass.zsh" ]; then
    . "${ZDOTDIR}/completion.d/pass.zsh"
fi

# vi-mode
bindkey -v

bindkey '^P' up-history
bindkey '^N' down-history
# bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^f' forward-char
bindkey '^b' backward-char

# function zle-line-init zle-keymap-select {
#     VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
#     RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$(git_prompt_status) $EPS1"
#     zle reset-prompt
# }

# zle -N zle-line-init
# zle -N zle-keymap-select
export KEYTIMEOUT=1
export HISTFILE="${XDG_CACHE_HOME}/zsh/history"

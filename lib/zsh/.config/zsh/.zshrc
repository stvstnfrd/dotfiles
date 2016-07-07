#!/bin/zsh
ZSH_COMPDUMP="${HOME}/.cache/zsh/compdump-${SHORT_HOST}-${ZSH_VERSION}"
if [ -s "${ZDOTDIR}/.oh-my-zshrc" ]; then
    . "${ZDOTDIR}/.oh-my-zshrc"
    # function zle-line-init zle-keymap-select {
    #     VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
    #     RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$(git_prompt_status) $EPS1"
    #     zle reset-prompt
    # }
    zle -N zle-line-init
    zle -N zle-keymap-select
    export KEYTIMEOUT=1
fi
if [ -s "${HOME}/.config/sh/rc" ]; then
    . "${HOME}/.config/sh/rc"
fi
HISTFILE="${XDG_CACHE_HOME}/zsh/history"

# Load all of the plugins
__dir_dotfiles_startup="${DFC}/etc/rc.d"
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

# bindkey -v

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

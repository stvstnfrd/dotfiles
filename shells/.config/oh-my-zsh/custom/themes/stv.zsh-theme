#!/bin/zsh
function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    echo '○'
}

function battery_charge {
    echo `$BAT_CHARGE` 2>/dev/null
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo ' (venv='$(basename ${VIRTUAL_ENV})')'
}

good='(✿◕‿◕)'
good='@(^_^%)@'
bad='¯\_(ツ%)_/¯'
bad='(╯°□°）╯︵ ┻━┻'
bad='@(>_<%)@'
bad='¯\_(ツ%)_/¯'
# if [ -n "$SSH_CLIENT" ]; then text=" ssh-session"; fi
PROMPT='
# %{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%}:%{$fg_bold[green]%}$(collapse_pwd)%{$reset_color%}
# %B%(?.%F{green}${good}.%F{red}${bad})%f%b%{$reset_color%}$(virtualenv_info)$(git_prompt_info)
# %{$reset_color%}'
# RPROMPT='$(battery_charge)'
# RPROMPT=${bad}
# RPS1='%(?..%?)'

ZSH_THEME_GIT_PROMPT_PREFIX=" (%{$fg[magenta]%}branch="
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
# ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

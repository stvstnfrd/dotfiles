#!/bin/sh
alias a='ansible '
alias ag='ag --pager=less '
# b
# c
alias d='vimdiff '
alias e='echo '
alias f='find '
alias g='git '
# map aliases from git to bash
# foreach git alias 'x', create bash alias 'gx'
if command -v git >/dev/null 2>&1; then
    alias g='git '
    for a in $(git var -l | sed -nE 's/^alias\.([^=]*)=.*/\1/p'); do
        # shellcheck disable=SC2139
        alias "g${a}=git ${a} "
    done
fi
alias h='head '
alias i='ipython '
# j
alias k='kill '
alias k9='kill -9 '
# l
_name=
for _level in $(seq 1 5); do
    _name="${_name}l"
    # shellcheck disable=SC2139
    alias "${_name}=ls-level ${_level}"
done
alias m='man '
alias n='npm '
alias ni='npm install '
alias o='open '
alias p='pip '
alias pi='pip install '
alias pie='pip install -e '
alias pif='pip freeze '
alias pir='pip install -r '
alias psg='ps | grep '
alias py='python '
# q
alias rg=grep-right
alias rgl=grep-right-list-files
alias rgl0=grep-right-list-files-null
alias rg_edit=grep-right-edit
alias rg_docs=grep-right-doc
alias rgd='rg_docs stvstnfrd ~/.config/dotfiles'
alias rg_py=grep-right-py
alias rg_web=grep-right-www
alias rs='rsync --progress -avh '
alias rsn='rsync --progress -navh '
alias s='ssh '
alias sag='sudo apt-get '
alias sagi='sudo apt-get install '
alias sagu='sudo apt-get update; sudo apt-get upgrade '
alias t='tee '
alias tgc='tar czvf '
alias tgx='tar xzvf '
alias to='touch '
alias u='uptime '
alias v='vim '
alias w='watch -n1 --color '
alias x='xargs '
alias x0='xargs -0 '
# y
# z

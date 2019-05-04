#!/bin/sh
if [ -n "${debug}" ]; then
    echo 'funk:mnemonic:interactive'
fi
alias ..='cd ..; ls'
alias ...='cd ../..; ls'
alias ....='cd ../../..; ls'
alias .....='cd ../../../..; ls'
alias a='ansible '
alias ag='ag --pager=less '
alias c='cd '
alias d='vimdiff '
alias e='echo '
alias f='find '
alias g='grep '
alias h='head '
alias i='ipython '
# j = autojump
alias k='kill '
alias k9='kill -9 '
alias l='ls '
alias la='ls -A '
alias ll='ls -lF '
alias lla='ls -lAF '
alias lal='ls -lAF '
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
# q?
alias r='rsync --progress -avh '
alias rn='rsync --progress -navh '
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

# map aliases from git to bash
# foreach git alias 'x', create bash alias 'gx'
eval $(git config --get-regexp '^alias\.[^ ]+' | \
	sed -e 's/^alias\.\([^ ]*\) \([^!].*\)$/alias g\1="git \1";/' \
	    -e 's/^alias\.\([^ ]*\) \!\(.*\)$/alias g\1="\2";/')

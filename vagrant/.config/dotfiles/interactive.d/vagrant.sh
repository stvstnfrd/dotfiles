#!/bin/sh
if [ -n "${debug}" ]; then
    echo 'funk:vagrant:interactive'
fi
alias vh='vagrant halt '
alias vha='vagrant-halt-all '
alias vr='vagrant reload '
alias vs='vagrant ssh '
alias vu='vagrant up '
alias vus='vagrant up; vagrant ssh '
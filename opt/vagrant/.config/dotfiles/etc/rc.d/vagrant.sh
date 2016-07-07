#!/bin/sh

alias vs='vagrant ssh '
alias vu='vagrant up '
alias vr='vagrant reload '

vus() {
    vagrant up
    vagrant ssh
}

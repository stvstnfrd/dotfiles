#!/bin/sh
if command -v vagrant >/dev/null 2>&1; then
    alias vh='vagrant halt '
    alias vha='vagrant-halt-all '
    alias vr='vagrant reload '
    alias vs='vagrant ssh '
    alias vu='vagrant up '
    alias vus='vagrant up; vagrant ssh '
fi

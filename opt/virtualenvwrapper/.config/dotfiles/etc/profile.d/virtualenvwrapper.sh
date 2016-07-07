#!/bin/sh
export WORKON_HOME=${HOME}/.venvs
export PROJECT_HOME=${HOME}/projects
if [ -s /usr/local/bin/virtualenvwrapper.sh ]; then
    . /usr/local/bin/virtualenvwrapper.sh
fi

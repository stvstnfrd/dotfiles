#!/bin/sh
export WORKON_HOME=${HOME}/.local/virtualenvs
export PROJECT_HOME=${HOME}/projects
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
# if [ -s ${HOME}/local/bin/python ]; then
    # . ${HOME}/local/bin/activate
    # pip install virtualenv virtualenvwrapper
    # deactivate
    # export VIRTUALENVWRAPPER_PYTHON=${HOME}/local/bin/python
# fi

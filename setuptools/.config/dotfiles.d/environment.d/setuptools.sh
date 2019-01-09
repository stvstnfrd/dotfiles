#!/bin/sh
if [ -n "${debug}" ]; then
    echo 'funk:setuptools:environment'
fi
export PYTHON_EGG_CACHE="${XDG_CACHE_HOME}/python-eggs"

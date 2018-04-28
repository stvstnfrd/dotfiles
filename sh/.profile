#!/bin/sh
if [ -n "${debug}" ]; then
    echo 'funk:sh:profile'
fi
# Default permissions for new files
# User has read + write
# Group is readonly
# Other get nothing
umask 0037

# Set some basic ENVIRONMENT variables
. "${HOME}/.config/sh/environment"

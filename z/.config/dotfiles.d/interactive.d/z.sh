#!/bin/sh
# $_Z_CMD to change the command name (default z).
# $_Z_NO_RESOLVE_SYMLINKS to prevent symlink resolution.
# $_Z_NO_PROMPT_COMMAND to handle PROMPT_COMMAND/precmd your-self.
# $_Z_EXCLUDE_DIRS to an array of directory trees to exclude.
# $_Z_OWNER to allow usage when in 'sudo -s' mode.
. ${HOME}/src/z/z.sh
function j(){
    if [ ${#} -gt 0 ]; then
        z ${@}
    else
        z "$(z -lt | awk '{print $2}' | tail -2 | head -1)"
    fi
}
function jj(){
    if [ ${#} -gt 0 ]; then
        z -r ${@}
    else
        recent="$(z -l | awk '{print $2}' | tail -1)"
        if [ "${recent}" = "$(pwd)" ]; then
            z "$(z -l | awk '{print $2}' | tail -2 | head -1)"
        else
            z "${recent}"
        fi
    fi
}

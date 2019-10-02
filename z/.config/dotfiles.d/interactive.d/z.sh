#!/bin/sh
# $_Z_CMD to change the command name (default z).
# $_Z_NO_RESOLVE_SYMLINKS to prevent symlink resolution.
# $_Z_NO_PROMPT_COMMAND to handle PROMPT_COMMAND/precmd your-self.
# $_Z_EXCLUDE_DIRS to an array of directory trees to exclude.
# $_Z_OWNER to allow usage when in 'sudo -s' mode.
export _Z_DATA=${XDG_CACHE_HOME}/z
. ${HOME}/src/z/z.sh

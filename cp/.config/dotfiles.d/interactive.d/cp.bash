# $_Z_CMD to change the command name (default z).
# $_Z_NO_RESOLVE_SYMLINKS to prevent symlink resolution.
# $_Z_NO_PROMPT_COMMAND to handle PROMPT_COMMAND/precmd your-self.
# $_Z_EXCLUDE_DIRS to an array of directory trees to exclude.
# $_Z_OWNER to allow usage when in 'sudo -s' mode.
if [ -e "${HOME}/src/z/z.sh" ]; then
    . "${HOME}/src/z/z.sh"
    function j(){
        if [ ${#} -gt 0 ]; then
            _z ${@} 2>&1
        else
            _z "$(_z -lt 2>&1 | awk '{print $2}' | tail -2 | head -1)" 2>&1
        fi
    }
    function jj(){
        if [ ${#} -gt 0 ]; then
            _z -r ${@} 2>&1
        else
            recent="$(_z -l 2>&1 | awk '{print $2}' | tail -1)"
            if [ "${recent}" = "$(pwd)" ]; then
                _z "$(_z -l 2>&1 | awk '{print $2}' | tail -2 | head -1)" 2>&1
            else
                _z "${recent}" 2>&1
            fi
        fi
    }
    alias jl=z
    alias c=j
    alias cc=jj
    alias cl=jl
fi

# $_Z_CMD to change the command name (default z).
# $_Z_NO_RESOLVE_SYMLINKS to prevent symlink resolution.
# $_Z_NO_PROMPT_COMMAND to handle PROMPT_COMMAND/precmd your-self.
# $_Z_EXCLUDE_DIRS to an array of directory trees to exclude.
# $_Z_OWNER to allow usage when in 'sudo -s' mode.
if [ -e "${HOME}/src/z/z.sh" ]; then
    # shellcheck source=cd/src/z/z.sh
    . "${HOME}/src/z/z.sh"
    j(){
        if [ ${#} -gt 0 ]; then
            _z "${@}" 2>&1
        else
            _z "$(_z -lt 2>&1 | awk '{print $2}' | tail -2 | head -1)" 2>&1
        fi
    }
    jj(){
        if [ ${#} -gt 0 ]; then
            _z -r "${@}" 2>&1
        else
            recent="$(_z -l 2>&1 | awk '{print $2}' | tail -1)"
            if [ "${recent}" = "$(pwd)" ]; then
                _z "$(_z -l 2>&1 | awk '{print $2}' | tail -2 | head -1)" 2>&1
            else
                _z "${recent}" 2>&1
            fi
        fi
    }
    if command -v fzf >/dev/null 2>&1
    then
        unalias z 2> /dev/null
        z() {
            [ $# -gt 0 ] && _z "$*" && return
            if selection="$(
                _z -l 2>&1 \
                | fzf \
                    --height 40% \
                    --nth 2.. \
                    --reverse \
                    --inline-info +s \
                    --tac \
                    --query "${*##-* }" \
                | sed 's/^[0-9,.]* *//' \
            )" && [ -n "${selection}" ]
            then
                cd "${selection}" || return 2
            else
                return 2
            fi
        }
    fi
    alias jl=z
    alias c=j
    alias cc=jj
    alias cl=jl
fi

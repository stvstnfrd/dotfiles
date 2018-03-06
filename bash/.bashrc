#!/bin/bash
if [ -n "${debug}" ]; then
    echo 'funk:bash:interactive'
fi
if [ -s "${HOME}/.config/sh/interactive" ]; then
    . "${HOME}/.config/sh/interactive"
fi
export HISTFILE="${XDG_CACHE_HOME}/bash/history"
if [ -s "${HOME}/.config/bash/options" ]; then
    . "${HOME}/.config/bash/options"
fi

PS1_EMOTICON() {
	local last_exit_code=${?}
	local emoticon_success='@(^_^)@'
	local emoticon_failure='@(>_<)@'
	local color_success='' #\e[32;1m'
	local color_failure='' #\e[31;1m'
	local color_stop='' #\e[0m'
	local output=''
	if [ "${last_exit_code}" = 0 ]; then
		output="${color_success}${emoticon_success}${color_stop}"
	else
		output="${color_failure}${emoticon_failure}${color_stop}"
	fi
	echo -ne ${output}
	return ${last_exit_code}
}
PS1=""
PS1="${PS1}\n#"
PS1="${PS1} \$(PS1_EMOTICON)"
PS1="${PS1} [\t]"
PS1="${PS1} [\u@\h:\w]"
PS1="${PS1}\n# "
export PS1

# Load all of the plugins
__dir_dotfiles_startup="${DFC}/interactive.d"
if [ -d "${__dir_dotfiles_startup}" ]; then
    __script_count=$(find "${__dir_dotfiles_startup}/" -name '*.bash' | wc -l | awk '{print $1}')
    if [ "${__script_count}" -gt 0 ]; then
        for plugin in ${__dir_dotfiles_startup}/*.bash; do
            if [ -r "${plugin}" ]; then
                . "${plugin}"
            fi
        done
        unset plugin
    fi
    unset __script_count
fi
unset __dir_dotfiles_startup

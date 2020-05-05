#!/bin/bash
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

#!/bin/sh
PS1_SHELL() {
	echo "[shell:sh]"
}

if [ -z "${ZSH_VERSION}" ] && [ -z "${BASH_VERSION}" ]; then
    PS1=""
    PS1="${PS1}

# $(PS1_SHELL)
# "
    export PS1
else
	if ! command -v __git_ps1 >/dev/null 2>&1; then
		if [ -e "${HOME}/.config/bash/git-sh-prompt" ]; then
			# shellcheck source=shells/.config/bash/git-sh-prompt
			# shellcheck disable=SC1091
			. "${HOME}/.config/bash/git-sh-prompt"
		fi
	fi
	PS1_EMOTICON() { (
		last_exit_code=${?}
		emoticon_success='@(^_^)@'
		emoticon_failure='@(>_<)@'
		color_success='\e[32;1m'
		color_failure='\e[31;1m'
		color_stop='\e[0m'
		output=''
		if [ "${last_exit_code}" = 0 ]; then
			output="${color_success}${emoticon_success}${color_stop}"
		else
			output="${color_failure}${emoticon_failure}${color_stop}"
		fi
		printf "%b" "${output}"
		return ${last_exit_code}
	) }

	PS1_GIT() { (
		# shellcheck disable=SC2119
		branch_info=$(__git_ps1 | tr -d '( )')
		if [ -n "${branch_info}" ]; then
			echo "[branch:${branch_info}]"
		fi
	) }

	PS1_NODE() { (
		if [ -n "${NVM_BIN}" ]; then
			version=$(echo "${NVM_BIN}" | sed 's@.*/v\([0-9.]\+\)/.*@\1@')
			echo "[node:${version}]"
		fi
	) }

	PS1_PATH() {
		PS1_HASH_COLOR "$(
			echo "${PWD}" \
			| sed 's@/home/[^/]\+@~@'
		)"
	}

	PS1_VENV() { (
		if [ -n "${VIRTUAL_ENV}" ]; then
			echo "[venv:$(basename "${VIRTUAL_ENV}")]"
		fi
	) }

	# cat /usr/share/dict/american-english | while read -r word; do printf '%s\n' "$(PS1_HASH_COLOR "${word}")"; sleep .25s; done
	PS1_HASH_COLOR() {
		text="${1}"
		hash="$(
			printf '%s' "${text}" \
			| md5sum \
			| awk '{print $1}' \
			| tr -d '\n' \
			| tail -c2 \
			| tr '[:lower:]' '[:upper:]' \
		)"
		hash="$(echo "ibase=16; ${hash} % FF" | bc)"
		color_hash="\e[${hash};1m"
		color_hash="\e[38;5;${hash}m"
		color_stop='\e[0m'
		output="${color_hash}${text}${color_stop}"
		printf "%b" "${output}"
	}
fi

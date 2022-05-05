#!/bin/sh
agent_dir="${XDG_STATE_HOME:-${HOME}/.local/var}/ssh"
agent_file="${agent_dir}/agent.sh"
log() {
	priority="${1}"
	shift
	logger "[${priority}] ${*}"
}
[ -d "${agent_dir}" ] || mkdir -p "${agent_dir}"
if [ -f "${agent_file}" ]
then
    # shellcheck disable=SC1090
    log INFO "Sourcing existing agent file: ${agent_file}"
    . "${agent_file}" >/dev/null
    log INFO "Sourced existing agent file: ${agent_file}"
    if ! kill -0 "${SSH_AGENT_PID}" >/dev/null 2>&1
    then
        log NOTICE "Stale agent file found; spawning new agent"
        eval "$(ssh-agent | tee "${agent_file}")"
        log NOTICE "Spawned new agent"
        ssh-add
    else
        log DEBUG "ssh-agent already running!"
    fi
else
    log INFO "Starting ssh-agent"
    eval "$(ssh-agent | tee "${agent_file}")"
    ssh-add
fi

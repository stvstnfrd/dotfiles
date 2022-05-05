#!/bin/bash
PS1_SHELL() {
	echo "[shell:bash]"
}

PS1="

# \$(PS1_EMOTICON) [\t]   [\$(PS1_HASH_COLOR ${USER})@\$(PS1_HASH_COLOR ${HOSTNAME}):\$(PS1_PATH)]
          \$(PS1_SHELL) \$(PS1_GIT) \$(PS1_VENV) \$(PS1_NODE)"
PS1="${PS1}\n# "
export PS1
# vim: tw=1000

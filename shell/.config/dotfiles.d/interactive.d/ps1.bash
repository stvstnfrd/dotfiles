#!/bin/bash
PS1_SHELL() {
	echo "[shell:bash]"
}

PS1="

# \$(PS1_EMOTICON) [\t]   [\u@\h:\w]
          \$(PS1_SHELL) \$(PS1_GIT) \$(PS1_VENV) \$(PS1_NODE)"
PS1="${PS1}\n# "
export PS1

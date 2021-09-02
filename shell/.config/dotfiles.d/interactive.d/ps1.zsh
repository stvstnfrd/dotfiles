#!/usr/bin/env zsh
PS1_SHELL() {
	echo "[shell:zsh]"
}

setopt PROMPT_SUBST ; PS1='

# $(PS1_EMOTICON) [%D{%H:%M:%S}]  [%n@%m:%~]
#         $(PS1_SHELL) $(PS1_GIT) $(PS1_VENV) $(PS1_NODE)
# '
export PS1

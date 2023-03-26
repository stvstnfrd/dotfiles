#!/usr/bin/env zsh
PS1_SHELL() {
	echo "[shell:zsh]"
}

setopt PROMPT_SUBST ; PS1='

# $(PS1_EMOTICON) [%D{%H:%M:%S}]  [$(PS1_HASH_COLOR ${USER})@$(PS1_HASH_COLOR ${HOST}):$(PS1_PATH)]
#         $(PS1_SHELL) $(PS1_GIT) $(PS1_VENV) $(PS1_NODE)
# '
export PS1
# vim: tw=1000

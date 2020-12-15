#!/bin/zsh
# ZSH does _not_ integrate with `readline` (see: `man zshzle`),
# so to avoid duplicating bindings from ${INPUTRC},
# we attempt some basic processing to do so semi-automatically.
# Use:
# - Annotate your ${INPUTRC} with end-of-line comments like:
#       `# zle=<key-action>`
#   where `<key-action>` is a bindkey action, like `down-history`, eg:
#       `Control-n: next-history  # zle=down-history`
# Support:
# - `Control-*`
# - all bindings are global; no mode-aware binding
_inputrc=${INPUTRC:-${HOME:-/home/${USER}}/.inputrc}
if [ -e "${_inputrc}" ]; then
	# ZSH defaults to emacs-mode:
	#   but, will use vi-mode if ${VISUAL} or ${EDITOR} contain 'vi',
	#   however, it's possible for system-wide configuration,
	#     eg: /etc/zsh/zshrc
	#     to set it to emacs-mode anyway :shrug:
	#   so, let's explicitly use the value from ${INPUTRC}.
	if grep '^set editing-mode vi\s*\(\#.*\)\?' "${_inputrc}" 2>&1 >/dev/null; then
		bindkey -v
	fi
	cat "${_inputrc}" \
	| grep -v '^\s*#' \
	| grep '# zle=' \
	| sed 's/^Control-\([^:]\+\)\s*:.*#\s*zle=/^\1 /' \
	| while read line; do
		bindkey -a -- "${=line}"
		bindkey -v -- "${=line}"
	  done \
	;
fi
unset _inputrc

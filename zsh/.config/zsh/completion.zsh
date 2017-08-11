#!/bin/zsh
if [ -n "${debug}" ]; then
    echo 'funk:zsh:completions'
fi
# Load and run compinit
autoload -U compinit
compinit -i -d "${ZSH_COMPDUMP}"

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end

# Save the location of the current completion dump file.
if [ -z "$ZSH_COMPDUMP" ]; then
  ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"
fi

WORDCHARS=''

zmodload -i zsh/complist

## case-insensitive (all),partial-word and then substring completion
if [ "x$CASE_SENSITIVE" = "xtrue" ]; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unset CASE_SENSITIVE
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
fi

zstyle ':completion:*' list-colors ''

# should this be in keybindings?
bindkey -M menuselect '^o' accept-and-infer-next-history

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
cdpath=(.)

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH/cache/

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'

# ... unless we really want to.
zstyle '*' single-ignored show

if [ "x$COMPLETION_WAITING_DOTS" = "xtrue" ]; then
  expand-or-complete-with-dots() {
    echo -n "\e[31m......\e[0m"
    zle expand-or-complete
    zle redisplay
  }
  zle -N expand-or-complete-with-dots
  bindkey "^I" expand-or-complete-with-dots
fi

_pass () {
	local cmd
	if (( CURRENT > 2)); then
		cmd=${words[2]}
		# Set the context for the subcommand.
		curcontext="${curcontext%:*:*}:pass-$cmd"
		# Narrow the range of words we are looking at to exclude `pass'
		(( CURRENT-- ))
		shift words
		# Run the completion for the subcommand
		case "${cmd}" in
			init)
				_arguments : \
					"-p[gpg-id will only be applied to this subfolder]" \
					"--path[gpg-id will only be applied to this subfolder]"
				_pass_complete_keys
				;;
			ls|list|edit)
				_pass_complete_entries_with_subdirs
				;;
			insert)
				_arguments : \
					"-e[echo password to console]" \
					"--echo[echo password to console]" \
					"-m[multiline]" \
					"--multiline[multiline]"
				_pass_complete_entries_with_subdirs
				;;
			generate)
				_arguments : \
					"-n[don't include symbols in password]" \
					"--no-symbols[don't include symbols in password]" \
					"-c[copy password to the clipboard]" \
					"--clip[copy password to the clipboard]" \
					"-f[force overwrite]" \
					"--force[force overwrite]" \
					"-i[replace first line]" \
					"--in-place[replace first line]"
				_pass_complete_entries_with_subdirs
				;;
			cp|copy|mv|rename)
				_arguments : \
					"-f[force rename]" \
					"--force[force rename]"
					_pass_complete_entries_with_subdirs
				;;
			rm)
				_arguments : \
					"-f[force deletion]" \
					"--force[force deletion]" \
					"-r[recursively delete]" \
					"--recursive[recursively delete]"
					_pass_complete_entries_with_subdirs
				;;
			git)
				local -a subcommands
				subcommands=(
					"init:Initialize git repository"
					"push:Push to remote repository"
					"pull:Pull from remote repository"
					"config:Show git config"
					"log:Show git log"
					"reflog:Show git reflog"
				)
				_describe -t commands 'pass git' subcommands
				;;
			show|*)
				_pass_cmd_show
				;;
		esac
	else
		local -a subcommands
		subcommands=(
			"init:Initialize new password storage"
			"ls:List passwords"
			"find:Find password files or directories based on pattern"
			"grep:Search inside decrypted password files for matching pattern"
			"show:Decrypt and print a password"
			"insert:Insert a new password"
			"generate:Generate a new password using pwgen"
			"edit:Edit a password with \$EDITOR"
			"mv:Rename the password"
			"cp:Copy the password"
			"rm:Remove the password"
			"git:Call git on the password store"
			"version:Output version information"
			"help:Output help message"
		)
		_describe -t commands 'pass' subcommands
		_arguments : \
			"--version[Output version information]" \
			"--help[Output help message]"
		_pass_cmd_show
	fi
}

_pass_cmd_show () {
	_arguments : \
		"-c[put it on the clipboard]" \
		"--clip[put it on the clipboard]"
	_pass_complete_entries
}
_pass_complete_entries_helper () {
	local IFS=$'\n'
	local prefix
	zstyle -s ":completion:${curcontext}:" prefix prefix || prefix="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
	_values -C 'passwords' ${$(find -L "$prefix" \( -name .git -o -name .gpg-id \) -prune -o $@ -print 2>/dev/null | sed -e "s#${prefix}/\{0,1\}##" -e 's#\.gpg##' -e 's#\\#\\\\#' | sort):-""}
}

_pass_complete_entries_with_subdirs () {
	_pass_complete_entries_helper
}

_pass_complete_entries () {
	_pass_complete_entries_helper -type f
}

_pass_complete_keys () {
	local IFS=$'\n'
	# Extract names and email addresses from gpg --list-keys
	_values 'gpg keys' $(gpg2 --list-secret-keys --with-colons | cut -d : -f 10 | sort -u | sed '/^$/d')
}

# _pass

compdef _pass pass
compdef _pass workpass
zstyle ':completion::complete:workpass::' prefix "$HOME/.team-pass"
workpass() {
    PASSWORD_STORE_DIR=${HOME}/.team-pass pass ${@}
}



## If on Mac, use GNU utils first
if [ -d "/usr/local/opt/coreutils/libexec/gnubin" ]; then
	PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
fi

## Create a ~/bin
mkdir -p ~/.local/bin 2>/dev/null || true
PATH="${HOME}/.local/bin:${HOME}/.local/scripts:$PATH"

## Interactive operation
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

## Colors
alias grep='grep --color'
alias egrep='egrep --color=auto'
alias ll='ls -lahF --group-directories-first --color=tty --hide="*.pyc" --hide="__pycache__"'

## Which
what() {
	(
		alias
		declare -f
	) | which --tty-only --read-alias --read-functions --show-tilde --show-dot $@
}
export -f what

## Others
alias tree='tree -C -I "__pycache__|*.pyc"'

# Alias vim to nvim if it exists
if [ -x "$(command -v nvim)" ]; then
	alias vim='nvim'
fi

# cd prints a list after switching
function cd() {
	local new_directory="$*"
	if [ $# -eq 0 ]; then
		new_directory=${HOME}
	fi

	# If directory arg is a file, cd into dir and vim file
	if [ -f "${new_directory}" ]; then
		cd $(dirname "${new_directory}")
		vim $(basename "${new_directory}")

	# path isn't a file so just cd
	else
		builtin cd "${new_directory}" && ls -1hF --group-directories-first --color=always --hide="*.pyc" --hide="__pycache__" | head -n 20
	fi
}

# Make dir and CD into it
function mkcd() {
	mkdir -p "$@" && cd "$@"
}

# Make a subdir in projects and cd to it
function mkproj() {
	mkcd "${HOME}/projects/$1"
}

# Create temporary dir and cd into it
function cdtmp() {
	cd $(mktemp -d)
}

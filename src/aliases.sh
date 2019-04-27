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

## Set GNU tools
if hash gls 2>/dev/null; then
	GNU_LS='gls'
else
	GNU_LS='ls'
fi
if hash gwhich 2>/dev/null; then
	GNU_WHICH='gwhich'
else
	GNU_WHICH='which'
fi

## ll
function ll() {
	LC_COLLATE=C $GNU_LS -lahF --group-directories-first --color=tty --hide="*.pyc" --hide="__pycache__"
}

## what
function what() {
	(
		alias
		declare -f
	) | $GNU_WHICH --tty-only --read-alias --read-functions --show-tilde --show-dot $@
}
export -f what

## vim files using rg
function vf() {
	nvim $(rg --files | fzf)
}

function vg() {
	nvim $(rg -l $* | fzf)
}

function vga() {
	nvim $(rg -l $*)
}

## Others

# Clipboard copy
function cb() {

	# x11 - Arch
	if hash xclip; then
		cat $1 | xclip -selection clipboard

	# macOS
	else
		cat $1 | pbcopy
	fi
}

alias tree='tree -C -I "__pycache__|*.pyc"'

# Watch with expansion
# Ref: https://unix.stackexchange.com/questions/25327/watch-command-alias-expansion
alias watch='watch '

# vim to nvim if it exists
if hash nvim 2>/dev/null; then
	alias vim='nvim'
fi

# cat to bat if it exists
if hash bat 2>/dev/null; then
	alias cat='bat'
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
		builtin cd "${new_directory}" && $GNU_LS -1hF --group-directories-first --color=always --hide="*.pyc" --hide="__pycache__" | head -n 20
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

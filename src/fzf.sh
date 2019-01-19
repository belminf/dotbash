# If this is a user setup, add to PATH
if [ -d "${HOME}/.fzf/bin" ] && [[ $PATH != *${HOME}/.fzf/bin* ]]; then
	FZF_SCRIPTS_DIR="${HOME}/.fzf/shell"
	PATH="$PATH:${HOME}/.fzf/bin"

# Check if installed system wide
elif [ -d "/usr/share/fzf" ]; then
	FZF_SCRIPTS_DIR="/usr/share/fzf"

# macOS (brew) install
elif [ -d "/usr/local/opt/fzf" ]; then
	FZF_SCRIPTS_DIR="/usr/local/opt/fzf/shell"
fi

# Source FZF bash files
if [ ! -z "${FZF_SCRIPTS_DIR}" ]; then
	source "${FZF_SCRIPTS_DIR}/completion.bash"
	source "${FZF_SCRIPTS_DIR}/key-bindings.bash"

	# Unbind Esc+C so it could be used to change lines
	bind "$(bind -s | grep '^"\\ec"' | sed 's/ec/C-q/')"
	[[ $- =~ i ]] && bind '"\ec": nop'
fi

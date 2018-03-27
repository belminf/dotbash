# If this is a user setup, add to PATH
if [ -d "${HOME}/.fzf/bin" ] && [[ ! "$PATH" == *${HOME}/.fzf/bin* ]]
then
  FZF_SCRIPTS_DIR="${HOME}/.fzf/shell"
  export PATH="$PATH:${HOME}/.fzf/bin"

# Check if installed system wide
elif [ -d "/usr/share/fzf" ]
then
  FZF_SCRIPTS_DIR="/usr/share/fzf"
fi

# Source FZF bash files
source "${FZF_SCRIPTS_DIR}/completion.bash"
source "${FZF_SCRIPTS_DIR}/key-bindings.bash"

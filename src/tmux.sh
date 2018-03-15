# Fixes ssh-agent issue with tmux

# Set new SSH_AUTH_SOCK
export SSH_AUTH_SOCK="${HOME}/.ssh/.auth_sock.$(hostname)"

# Run ssh-agent if not already running
pgrep -u $USER ssh-agent > /dev/null 2>&1 || echo "hi" && ssh-agent -a $SSH_AUTH_SOCK > /dev/null 2>&1

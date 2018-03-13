# Fixes ssh-agent issue with tmux

# Run ssh-agent if not already running
pgrep -u $USER ssh-agent > /dev/null 2>&1 || ssh-agent > /dev/null 2>&1

# Set new SSH_AUTH_SOCK
export SSH_AUTH_SOCK="${HOME}/.ssh/.auth_sock.$(hostname)"

# Link SSH agent file
CURRENT_AUTH_SOCK="$(find /tmp -type s -printf "%T@ %p\n" 2> /dev/null | grep ssh | sort -n  | cut -d' ' -f 2- | tail -n 1)"
ln -sf "$CURRENT_AUTH_SOCK" "$SSH_AUTH_SOCK"

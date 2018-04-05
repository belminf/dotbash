# Fixes ssh-agent issue with tmux
export SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-${HOME}/.ssh/.auth_sock.$(hostname)}"

# Only do stuff if ssh-agent is not already running
if ! pgrep -u $USER ssh-agent > /dev/null 2>&1
then

  # Run ssh-agent if not already running
  rm -f $SSH_AUTH_SOCK 2> /dev/null
  ssh-agent -a $SSH_AUTH_SOCK > /dev/null 2>&1

fi

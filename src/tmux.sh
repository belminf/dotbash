# Fixes ssh-agent issue with tmux

if ! pgrep -u $USER ssh-agent > /dev/null 2>&1
then

  # Set new SSH_AUTH_SOCK
  export SSH_AUTH_SOCK="${HOME}/.ssh/.auth_sock.$(hostname)"

  # Run ssh-agent if not already running
  rm -f $SSH_AUTH_SOCK 2> /dev/null
  ssh-agent -a $SSH_AUTH_SOCK > /dev/null 2>&1

fi

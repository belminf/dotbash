# Consistent SSH auth sock to work around tmux issue

# Function
function update_ssh_agent {

  # Generate path
  SOCK_PATH="${HOME}/.ssh-agent-${USER}-tmux"
  
  # If not already changed, save old path
  if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK_PATH ]
  then

    # Save this session's auth sock
    export MY_SSH_AUTH_SOCK=$SSH_AUTH_SOCK
  fi

  if test $MY_SSH_AUTH_SOCK
  then

    # Remove previously linked auth sock
    unlink $SOCK_PATH 2> /dev/null

    # Link and export
    ln -s $MY_SSH_AUTH_SOCK $SOCK_PATH
    export SSH_AUTH_SOCK=$SOCK_PATH
  else
    echo "Error: No SSH auth sock saved (\$MY_SSH_AUTH_SOCK)"
    return 1
  fi
}

# First run
update_ssh_agent

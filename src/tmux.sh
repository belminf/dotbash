# Consistent SSH auth sock to work around tmux issue
SOCK_PATH="$HOME/ssh-agent-$USER-tmux"
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK_PATH ]
then
  unlink $SOCK_PATH 2> /dev/null
  ln -s $SSH_AUTH_SOCK $SOCK_PATH
  export SSH_AUTH_SOCK=$SOCK_PATH
fi

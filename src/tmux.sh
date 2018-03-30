# Fixes ssh-agent issue with tmux

# Set new SSH_AUTH_SOCK
export SSH_AUTH_SOCK="${HOME}/.ssh/.auth_sock.$(hostname)"

# Run ssh-agent if not already running
pgrep -u $USER ssh-agent > /dev/null 2>&1 || rm -f $SSH_AUTH_SOCK 2> /dev/null; ssh-agent -a $SSH_AUTH_SOCK > /dev/null 2>&1

# If auth sock is a symlink, update it
if [ -L $SSH_AUTH_SOCK ] || ! [ -e $SSH_AUTH_SOCK ]
then
    ln -sf $(ls -dt1 /tmp/ssh-*/* | head -n 1) $SSH_AUTH_SOCK 2> /dev/null
fi

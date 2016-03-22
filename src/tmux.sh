# Consistent SSH auth sock to work around tmux issue

# Function
function update_ssh_agent {

  # Reload tmux
  eval $(tmux show-environment -s)
}

# Only do this if in TMUX
if  [ -n "$TMUX" ]
then
  update_ssh_agent
fi

# Consistent SSH auth sock to work around tmux issue

# Function
function update_ssh_agent {

  # Reload tmux
  $(tmux show-environment -s)
}

# First run
update_ssh_agent

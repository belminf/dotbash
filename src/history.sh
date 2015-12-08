# History settings
export HISTSIZE=1000000

# Ignore commands that start with spaces
export HISTCONTROL='ignorespace'

# Ignore ls,bg,fg,exit
export HISTIGNORE='&:ls:[bf]g:exit'

# Add time to history
export HISTTIMEFORMAT='%b %d %H:%M:%S: '

# Save history right away
export PROMPT_COMMAND='history -a'

shopt -s histappend
shopt -s cmdhist

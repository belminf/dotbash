# Update history right away
export PROMPT_COMMAND='history -a'

# If tmux, also update title
if [[ $TMUX ]]
then
  export PROMPT_COMMAND='printf "\033k$( [ -z $SSH_TTY ] && echo "" || echo ${HOSTNAME%%.*}:)$(basename $(dirs))\033\\";history -a'
fi

# Disable virtualenv PS
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Get virtualenv
function print_virtualenv() {

  # See if we are in virtualenv
  if [[ -n "$VIRTUAL_ENV" ]]
  then
    # Strip out the path and just leave the env name
    echo "(${VIRTUAL_ENV##*/})"
  fi
  
  # ASSERT: Not in a virtualenv, echo nothing
}

# Get virtualenv
function print_userhost() {

  # See if we are in SSH
  if [[ "$SSH_TTY" ]]
  then
    echo "\u@\h"
  fi
}

# Create prompt with colors
if tty -s
then
  fg_green="$(tput setaf 2)"
  fg_yellow="$(tput setaf 3)"
  fg_blue="$(tput setaf 4)"
  bold="$(tput bold)"
  reset="$(tput sgr0)"
  PS1="\n\[$reset$fg_green$bold\][\t] \[$reset$fg_green\]\w\n\[$reset$fg_yellow$bold\]\$(print_userhost)\$(print_virtualenv)\$\[$reset\] ";
fi

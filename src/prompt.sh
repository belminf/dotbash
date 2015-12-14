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

# Create prompt with colors
if tty -s
then
  fg_green="$(tput setaf 2)"
  fg_yellow="$(tput setaf 3)"
  fg_blue="$(tput setaf 4)"
  bold="$(tput bold)"
  reset="$(tput sgr0)"
  if uname | grep CYGWIN > /dev/null 2>&1
  then
    PS1="\n\[$reset$fg_green$bold\][\t] \[$reset$fg_green\]\w\n\$(print_virtualenv)\$\[$reset\] "
  else
    PS1="\n\[$reset$fg_green$bold\][\t] \[$reset$fg_green\]\w\n\[$reset$fg_yellow$bold\]\u@\h \$(print_virtualenv)\$\[$reset\] ";
  fi
fi

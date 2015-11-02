# Prompt
if [[ -bash == *bash* ]] && tty -s
then
  fg_green="$(tput setaf 2)"
  fg_yellow="$(tput setaf 3)"
  fg_blue="$(tput setaf 4)"
  bold="$(tput bold)"
  reset="$(tput sgr0)"
  if uname | grep CYGWIN > /dev/null 2>&1
  then
    PS1="\n\[$reset$fg_green$bold\][\t] \[$reset$fg_green\]\w\n\$\[$reset\] "
  else
    PS1="\n\[$reset$fg_green$bold\][\t] \[$reset$fg_green\]\w\n\[$reset$fg_yellow$bold\]\u@\h \$\[$reset\] ";
  fi
fi

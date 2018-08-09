## Create a ~/bin
mkdir -p ~/.local/bin 2> /dev/null || true
export PATH="${HOME}/.local/bin:${HOME}/.local/scripts:$PATH"

## Interactive operation
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

## Colors
alias grep='grep --color'
alias egrep='egrep --color=auto'
alias ll='ls -lahF --group-directories-first --color=tty --hide="*.pyc" --hide="__pycache__"'

## Which
what () {
    (alias; declare -f) | /usr/bin/which --tty-only --read-alias --read-functions --show-tilde --show-dot $@
}
export -f what

## Others
alias tree='tree -C -I "__pycache__|*.pyc"'

# cd prints a list after switching
function cd() {
  new_directory="$*";
  if [ $# -eq 0  ]; then 
    new_directory=${HOME};
  fi;
  builtin cd "${new_directory}" && ls -F --group-directories-first --color=tty
}

# Make dir and CD into it
function mkcd() {
  mkdir -p "$@" && cd "$@"
}

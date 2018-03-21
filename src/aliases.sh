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

## Others
alias ll='ls -lhF --group-directories-first --color=tty --hide="*.pyc" --hide="__pycache__"'
alias what='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'

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

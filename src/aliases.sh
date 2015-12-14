## Create a ~/bin
mkdir -p ~/local/bin 2> /dev/null || true
export PATH="$HOME/local/bin:$PATH"

## Interactive operation
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

## Colors
alias grep='grep --color'
alias egrep='egrep --color=auto'

## Others
alias ll='ls -lh --color=tty'
alias what='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'

# Update env
function update_env {
  echo 'bash update...'
  (cd ${HOME}/.bash && git pull && git status --porcelain)
  
  echo ''
  echo 'vim update...';
  (cd ${HOME}/.vim && git pull && git status --porcelain)

  if [ -d "${HOME}/.tmux" ]
  then
    echo ''
    echo 'tmux update...'
    (cd ${HOME}/.tmux && git pull && git status --porcelain)
  fi
}

# tmux SSH
function s {
  for h
  do
    tmux find-window -N ssh:$h 2> /dev/null || tmux new-window -n ssh:$h ssh $h 
  done
}

# Make dir and CD into it
function mkcd() {
  mkdir -p "$@" && cd "$@"
}

# dated backup
function bup() {
  if [ -z "$1" ]; then
    echo "Usage: bup <file>"
    return 1
  fi

  if [ ! -f "$1" ]; then
    echo "Error: File does not exist"
    return 1
  fi

  local DATESTR="$(date "+%Y.%m.%d")"

  if [ -z "$2" ]; then
    \cp -ia $1{,".$DATESTR"}
  else
    \cp -ia $1{,".${DATESTR}-$2"}
  fi
}

# Functions
function extract {
  if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
  else
    if [ -f $1 ] ; then
        # NAME=${1%.*}
        # mkdir $NAME && cd $NAME
        case $1 in
          *.tar.bz2)   tar xvjf ../$1    ;;
          *.tar.gz)    tar xvzf ../$1    ;;
          *.tar.xz)    tar xvJf ../$1    ;;
          *.lzma)      unlzma ../$1      ;;
          *.bz2)       bunzip2 ../$1     ;;
          *.rar)       unrar x -ad ../$1 ;;
          *.gz)        gunzip ../$1      ;;
          *.tar)       tar xvf ../$1     ;;
          *.tbz2)      tar xvjf ../$1    ;;
          *.tgz)       tar xvzf ../$1    ;;
          *.zip)       unzip ../$1       ;;
          *.Z)         uncompress ../$1  ;;
          *.7z)        7z x ../$1        ;;
          *.xz)        unxz ../$1        ;;
          *.exe)       cabextract ../$1  ;;
          *)           echo "extract: '$1' - unknown archive method" ;;
        esac
    else
        echo "$1 - file does not exist"
    fi
  fi
}


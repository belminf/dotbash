# Disable virtualenv PS
VIRTUAL_ENV_DISABLE_PROMPT=1

# Refresh ps1
PROMPT_COMMAND="set_ps1"

# Update history right away
PROMPT_COMMAND="${PROMPT_COMMAND};history -a"

# If tmux, also update title
if [[ $TMUX ]]
then
  TMUX_TITLE_UPDATE='printf "\033k$( [ -z $SSH_TTY ] && echo "" || echo ${HOSTNAME%%.*}:)$(basename $(dirs))\033\\"'
  PROMPT_COMMAND="${PROMPT_COMMAND};${TMUX_TITLE_UPDATE}"
fi

# Tput variables
COLOR_FG_GREEN="\[$(tput setaf 2)\]"
COLOR_FG_YELLOW="\[$(tput setaf 3)\]"
COLOR_FG_BLUE="\[$(tput setaf 4)\]"
COLOR_FG_CYAN="\[$(tput setaf 6)\]"
COLOR_FG_WHITE="\[$(tput setaf 7)\]"
COLOR_FG_RED="\[$(tput setaf 1)\]"
COLOR_BOLD="\[$(tput bold)\]"
COLOR_RESET="\[$(tput sgr0)\]"
CURSOR_SAVE="\[$(tput sc)\]"
CURSOR_RESTORE="\[$(tput rc)\]"

# Get virtualenv
function print_virtualenv() {

  # See if we are in virtualenv
  if [[ -n "$VIRTUAL_ENV" ]]
  then

    # Strip out the path and just leave the env name
    echo "${COLOR_FG_CYAN}${VIRTUAL_ENV##*/}${COLOR_RESET}"
  fi

  # ASSERT: Don't print env if not in one
}

# Get user@host
function print_userhost() {

  # See if we are in SSH
  if [[ "$SSH_TTY" ]]
  then
    echo "\u@\h "
  fi

  # ASSERT: Don't print u@h if local
}

# Get git status
# Ref: https://gist.github.com/insin/1425703
function print_git_info {

  # See if we're in a git repo
  if git branch > /dev/null 2>&1
  then

    # Capture the output of the "git status" command.
    git_status="$(git status 2> /dev/null)"
    
    # Set color based on clean/staged/dirty.
    if [[ ${git_status} =~ "working tree clean" ]]; then
      state="${COLOR_FG_GREEN}"
    elif [[ ${git_status} =~ "Changes to be committed" ]]; then
      state="${COLOR_FG_YELLOW}"
    else
      state="${COLOR_FG_RED}"
    fi
    
    # Set arrow icon based on status against remote.
    remote_pattern="^Your branch is (.*) of"
    if [[ ${git_status} =~ ${remote_pattern} ]]; then
      if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="↑"
      else
      remote="↓"
      fi
    else
      remote=""
    fi
    diverge_pattern="^Your branch and .* have diverged"
    if [[ ${git_status} =~ ${diverge_pattern} ]]; then
      remote="↕"
    fi
    
    # Get the name of the branch.
    branch_pattern="^On branch ([^${IFS}]*)"
    if [[ ${git_status} =~ ${branch_pattern} ]]; then
      branch=${BASH_REMATCH[1]}
    fi
    
    # Set the final branch string.
    echo "${state}(${branch})${remote}${COLOR_RESET}"
  fi
}


# Save symbol coloring based on last retval
function set_prompt_symbol() {
  if [ "$1" -eq "0" ]
  then
    PROMPT_SYMBOL="\$"
  else
    PROMPT_SYMBOL="${COLOR_FG_RED}\$${COLOR_RESET}"
  fi
}

# Add context to the RHS
# Ref: https://superuser.com/a/1203400/48807
function add_rhs_ps1() {
  RHS_PS1="$(print_git_info) $(print_virtualenv)"
  RHS_PS1="$(sed "s/[[:space:]]*$//" <<< "$RHS_PS1")"
  RHS_PS1_CLEAN="$(sed "s/\x1B[^m]*m\|\\\\\[\|\\\\\]//g" <<< "$RHS_PS1")"

  PS1="${PS1}\[${CURSOR_SAVE}\e[${COLUMNS}C\e[${#RHS_PS1_CLEAN}D${RHS_PS1}${CURSOR_RESTORE}\]"
}

# Add first line of prompt
function add_first_ps1() {
  PS1="${PS1}${COLOR_RESET}${COLOR_FG_CYAN}\t ${COLOR_RESET}${COLOR_FG_GREEN}\w\n"
}

# Add second line of prompt
function add_second_ps1() {
  PS1="${PS1}${COLOR_RESET}${COLOR_FG_CYAN}$(print_userhost)${PROMPT_SYMBOL}${COLOR_RESET} "
}

function set_ps1() {

  # Save last retval
  set_prompt_symbol $?
  
  # Reset PS1
  PS1="\n"

  # Add all parts
  add_rhs_ps1 
  add_first_ps1
  add_second_ps1
}

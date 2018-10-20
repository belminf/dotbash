# Disable virtualenv PS
VIRTUAL_ENV_DISABLE_PROMPT=1

# Load VTE conf if exists
if [ -f /etc/profile.d/vte.sh ]
then
    . /etc/profile.d/vte.sh
fi

# Refresh ps1
if [ -z "$PROMPT_COMMAND" ]
then
    PROMPT_COMMAND="set_ps1"
else
    PROMPT_COMMAND="${PROMPT_COMMAND};set_ps1"
fi

# Update history right away
PROMPT_COMMAND="${PROMPT_COMMAND};history -a"

# Tput variables
COLOR_1="\[$(tput setaf 12)\]"
COLOR_2="\[$(tput setaf 144)\]"
COLOR_GOOD="\[$(tput setaf 35)\]"
COLOR_SOSO="\[$(tput setaf 117)\]"
COLOR_BAD="\[$(tput setaf 124)\]"
COLOR_RHS="\[$(tput setaf 74)\]"
COLOR_SEP="\[$(tput setaf 239)\]"
COLOR_DIM="\[$(tput dim)\]"
COLOR_BOLD="\[$(tput bold)\]"
COLOR_RESET="\[$(tput sgr0)\]"
CURSOR_SAVE="\[$(tput sc)\]"
CURSOR_RESTORE="\[$(tput rc)\]"

GIT_CLEAN_RE="working (tree|directory) clean"
GIT_PENDING_PUSH_RE="Changes to be committed"

# Get virtualenv
function print_virtualenv() {

  # See if we are in virtualenv
  if [[ -n "$VIRTUAL_ENV" ]]
  then

    # Strip out the path and just leave the env name
    echo "${COLOR_GOOD}ℙ ${COLOR_RHS}${VIRTUAL_ENV##*/}"
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
    if [[ "${git_status}" =~ $GIT_CLEAN_RE ]]; then
      state="${COLOR_GOOD}"
    elif [[ "${git_status}" =~ $GIT_PENDING_PUSH_RE ]]; then
      state="${COLOR_SOSO}"
    else
      state="${COLOR_BAD}"
    fi

    # Set arrow icon based on status against remote.
    remote_pattern="Your branch is (.*) of"
    if [[ ${git_status} =~ ${remote_pattern} ]]; then
      if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
        remote="↑ "
      else
        remote="↓ "
      fi
    else
      remote="↔ "
    fi
    diverge_pattern="Your branch and .* have diverged"
    if [[ ${git_status} =~ ${diverge_pattern} ]]; then
      remote="↕ "
    fi

    # Get the name of the branch.
    branch_pattern="^On branch ([^[:space:]]*)"
    if [[ ${git_status} =~ ${branch_pattern} ]]; then
      branch=${BASH_REMATCH[1]}
    fi

    # Set the final branch string.
    echo "${state}${remote}${COLOR_RHS}${branch}"
  fi
}

function print_knife_info {
  if [ -n "$(type -t _knife-block_ps1)" ] && [ "$(type -t _knife-block_ps1)" = function ]
  then
	echo "${COLOR_GOOD}⍃ ${COLOR_RHS}$(_knife-block_ps1)"
  fi
}

function print_aws_info {
    if [ ! -z "$AWS_PROFILE" ]
    then
        echo "${COLOR_GOOD}α ${COLOR_RHS}${AWS_PROFILE}"
    fi
}

# Save symbol coloring based on last retval
function set_prompt_symbol() {
  if [ "$1" -eq "0" ]
  then
    PROMPT_SYMBOL="\$"
  else
    PROMPT_SYMBOL="${COLOR_BAD}\$${COLOR_RESET}"
  fi
}

# Add context to the RHS
# Ref: https://superuser.com/a/1203400/48807
function add_rhs_ps1() {
  INFO_GIT="$(print_git_info)"
  INFO_VENV="$(print_virtualenv)"
  INFO_KNIFE="$(print_knife_info)"
  INFO_AWSPROFILE="$(print_aws_info)"

  RHS_PS1=""
  for INFO_SNIPPET in "$INFO_GIT" "$INFO_VENV" "$INFO_KNIFE" "$INFO_AWSPROFILE"
  do
      if [ ! -z "$INFO_SNIPPET" ]
      then
          if [ ! -z "$RHS_PS1" ]
          then
              RHS_PS1="${RHS_PS1} ${COLOR_SEP}⸗${COLOR_RESET} "
          fi
          RHS_PS1="${RHS_PS1}${INFO_SNIPPET}"
      fi
  done

  # Trailing and leading spaces
  RHS_PS1="$(echo "$RHS_PS1" | sed "s/[[:space:]]*$//")"
  RHS_PS1="$(echo "$RHS_PS1" | sed "s/^[[:space:]]*//")"
  RHS_PS1_CLEAN="$(echo -n "$RHS_PS1" | sed -r "s,\x1B\[[^m]*m(\x0F)?,,g" | sed -r 's,\\(\[|\]),,g')"

  PS1="${PS1}${CURSOR_SAVE}\e[${COLUMNS}C\e[${#RHS_PS1_CLEAN}D${RHS_PS1}${COLOR_RESET}${CURSOR_RESTORE}"
}

# Add first line of prompt
function add_first_ps1() {
  PS1="${PS1}${COLOR_RESET}${COLOR_1}\t ${COLOR_RESET}${COLOR_2}\w\n"
}

# Add second line of prompt
function add_second_ps1() {
  PS1="${PS1}${COLOR_RESET}${COLOR_1}$(print_userhost)${PROMPT_SYMBOL}${COLOR_RESET} "
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

# Disable virtualenv PS
VIRTUAL_ENV_DISABLE_PROMPT=1

# Load VTE conf if exists
if [ -f /etc/profile.d/vte.sh ]; then
	. /etc/profile.d/vte.sh
fi

# Refresh ps1
if [ -z "$PROMPT_COMMAND" ]; then
	PROMPT_COMMAND="set_ps1"
else
	PROMPT_COMMAND="${PROMPT_COMMAND};set_ps1"
fi

# Update history right away
PROMPT_COMMAND="${PROMPT_COMMAND};history -a"

# Tput variables
PS_COLOR_PRIMARY="\[$(tput setaf 12)\]"
PS_COLOR_SECONDARY="\[$(tput setaf 144)\]"
PS_COLOR_GOOD="\[$(tput setaf 35)\]"
PS_COLOR_SOSO="\[$(tput setaf 117)\]"
PS_COLOR_BAD="\[$(tput setaf 124)\]"
PS_COLOR_RHS="\[$(tput setaf 74)\]"
PS_COLOR_SEP="\[$(tput setaf 239)\]"
PS_COLOR_RESET="\[$(tput sgr0)\]"
PS_CURSOR_SAVE="\[$(tput sc)\]"
PS_CURSOR_RESTORE="\[$(tput rc)\]"

# git regex patterns
PS_GIT_CLEAN_RE="working (tree|directory) clean"
PS_GIT_PENDING_PUSH_RE="Changes to be committed"
PS_GIT_REMOTE_RE="Your branch is (.*) of"
PS_GIT_DIVERGE_RE="Your branch and .* have diverged"
PS_GIT_BRANCH_RE="^On branch ([^[:space:]]*)"

# Get virtualenv
function print_virtualenv() {

	# See if we are in virtualenv
	if [[ -n $VIRTUAL_ENV ]]; then

		# Strip out the path and just leave the env name
		echo -n "${PS_COLOR_GOOD}py/${PS_COLOR_RHS}${VIRTUAL_ENV##*/}"
	fi

	# ASSERT: Don't print env if not in one
}

# Get user@host
function print_userhost() {

	# See if we are in SSH
	if [[ "$SSH_TTY" ]]; then
		echo -n "\u@\h "
	fi

	# ASSERT: Don't print u@h if local
}

# Get git status
# Ref: https://gist.github.com/insin/1425703
function print_git_info() {

	# See if we're in a git repo
	if git branch >/dev/null 2>&1; then

		# Capture the output of the "git status" command.
		local git_status="$(git status 2>/dev/null)"

		# Set color based on clean/staged/dirty.
		if [[ ${git_status} =~ $PS_GIT_CLEAN_RE ]]; then
			echo -n "${PS_COLOR_GOOD}"
		elif [[ ${git_status} =~ $PS_GIT_PENDING_PUSH_RE ]]; then
			echo -n "${PS_COLOR_SOSO}"
		else
			echo -n "${PS_COLOR_BAD}"
		fi

		# Set arrow icon based on status against remote.
		if [[ ${git_status} =~ ${PS_GIT_REMOTE_RE} ]]; then
			if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
				echo -n "↑ "
			else
				echo -n "↓ "
			fi
		elif [[ ${git_status} =~ ${PS_GIT_DIVERGE_RE} ]]; then
			echo -n "↲ "
		else
			echo -n "⇵ "
		fi

		# Print color
		echo -n "$PS_COLOR_RHS"

		# Get the name of the branch.
		if [[ ${git_status} =~ ${PS_GIT_BRANCH_RE} ]]; then
			echo -n "${BASH_REMATCH[1]}"
		fi
	fi
}

function print_k8s_info() {

	local k8s_context="$(kubectl config current-context 2>/dev/null)"
	local k8s_ns="$(kubectl config view --minify -o jsonpath='{..namespace}' 2>/dev/null)"

	if [[ -n $k8s_context ]]; then
		if [[ -z $k8s_ns ]] || [ "$k8s_ns" = "default" ]; then
			echo -n "${PS_COLOR_GOOD}k8s/${PS_COLOR_RHS}${k8s_context}"
		else
			echo -n "${PS_COLOR_GOOD}k8s/${PS_COLOR_RHS}${k8s_ns}${PS_COLOR_SEP}:${PS_COLOR_RHS}${k8s_context}"
		fi
	fi
}
function print_knife_info() {

	local current_chef=""

	if [ -f ".chef/knife.rb" ] && [ ! ./ -ef ~ ]; then
		current_chef="$(grep chef_server_url .chef/knife.rb 2>/dev/null | awk -F[/:] '{print $4}')"
	fi

	if [ -z "$current_chef" ] && [ -n "$(type -t _knife-block_ps1)" ] && [ "$(type -t _knife-block_ps1)" = function ]; then
		current_chef="$(_knife-block_ps1)"
	fi

	if [ ! -z "$current_chef" ]; then
		echo -n "${PS_COLOR_GOOD}knf/${PS_COLOR_RHS}${current_chef}"
	fi
}

function print_aws_info() {
	if [ ! -z "$AWS_PROFILE" ]; then
		echo -n "${PS_COLOR_GOOD}aws/${PS_COLOR_RHS}${AWS_PROFILE}"
	fi
}

# Save symbol coloring based on last retval
function set_prompt_symbol() {
	if [ "$1" -eq "0" ]; then
		PROMPT_SYMBOL='$'
	else
		PROMPT_SYMBOL="${PS_COLOR_BAD}\$${PS_COLOR_RESET}"
	fi
}

# Add context to the RHS
# Ref: https://superuser.com/a/1203400/48807
function add_rhs_ps1() {
	local info_git="$(print_git_info)"
	local info_k8s="$(print_k8s_info)"
	local info_venv="$(print_virtualenv)"
	local info_knife="$(print_knife_info)"
	local info_awsprofile="$(print_aws_info)"

	local rhs_ps1=""
	for info_snippet in "$info_git" "$info_k8s" "$info_venv" "$info_knife" "$info_awsprofile"; do
		if [ ! -z "$info_snippet" ]; then
			if [ ! -z "$rhs_ps1" ]; then
				rhs_ps1="${rhs_ps1} ${PS_COLOR_SEP}⸗ "
			fi
			rhs_ps1="${rhs_ps1}${info_snippet}"
		fi
	done

	# Remove formatting to get printable count
	if hash gsed 2>/dev/null; then
		rhs_ps1_clean="$(echo -n "$rhs_ps1" | gsed "s/\\\\\[\x1B\[[^\]*\\\\]//g")"
	else
		rhs_ps1_clean="$(echo -n "$rhs_ps1" | sed "s/\\\\\[\x1B\[[^\]*\\\\]//g")"
	fi

	PS1="${PS1}${PS_CURSOR_SAVE}\e[${COLUMNS}C\e[${#rhs_ps1_clean}D${rhs_ps1}${PS_COLOR_RESET}${PS_CURSOR_RESTORE}"
}

# Add first line of prompt
function add_first_ps1() {
	PS1="${PS1}${PS_COLOR_RESET}${PS_COLOR_PRIMARY}\t ${PS_COLOR_RESET}${PS_COLOR_SECONDARY}\w\n"
}

# Add second line of prompt
function add_second_ps1() {
	PS1="${PS1}${PS_COLOR_RESET}${PS_COLOR_PRIMARY}$(print_userhost)${PROMPT_SYMBOL}${PS_COLOR_RESET} "
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

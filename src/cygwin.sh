# SSH pageant
if uname | grep CYGWIN >/dev/null 2>&1; then
	eval "$(ssh-pageant -ra /.ssh-pageant)"

	# For Ansible, per https://github.com/belminf/ansible-playbooks
	export CFLAGS="-D_DEFAULT_SOURCE"
fi

export SSH_AUTH_SOCK="${HOME}/.ssh/.ssh_agent"

[ -S "$SSH_AUTH_SOCK" ] || eval "$(ssh-agent -a "$SSH_AUTH_SOCK")"

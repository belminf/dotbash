# Source bash-completion if available

## Arch
source /usr/share/bash-completion/bash_completion 2>/dev/null

## macOS (brew)
hash brew 2>/dev/null && source "$(brew --prefix)/etc/bash_completion"

# Treat hyphens and underscores as equivalent
bind "set completion-map-case on"

# Display matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"

# Immediately add a trailing slash when autocompleting symlinks to directories
bind "set mark-symlinked-directories on"

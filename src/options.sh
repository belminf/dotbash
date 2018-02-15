# Turn off stty flow control
stty -ixon

# Don't clobber files
set -o noclobber

# Auto CD when a directory is set
## Not supportd in RHEL5
shopt -s autocd 2> /dev/null || true

# Spell correction
shopt -s cdspell

# Resize window
shopt -s checkwinsize

# Set VI mode
set -o vi

# Turn off stty flow control
stty -ixon

# Don't clobber files
set -o noclobber

# Auto CD when a directory is set
## Not supportd in RHEL5
shopt -s autocd

# Correct spelling errors during tab-completion
shopt -s dirspell

# Correct spelling errors in arguments supplied to cd
shopt -s cdspell

# Resize window
shopt -s checkwinsize

# Set VI mode
set -o vi

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

# Turn on recursive globbing (enables ** to recurse all directories)
shopt -s globstar 2> /dev/null

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

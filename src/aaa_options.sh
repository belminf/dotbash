#!/bin/bash

# Turn off stty flow control
stty -ixon

# Don't clobber files
set -o noclobber

# Resize window
shopt -s checkwinsize

# Set VI mode
set -o vi

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

# Turn on recursive globbing (enables ** to recurse all directories)
shopt -s globstar 2>/dev/null

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Ignore hidden files on match
bind 'set match-hidden-files off'
export GLOBIGNORE="__pycache__"
export FIGNORE="__pycache__:.git:.pyc:.o"

#!/bin/bash

# Editor env
PAGER=$(command -v less)
export PAGER
EDITOR=$(command -v nvim)
export EDITOR
export LESS='-XRF'

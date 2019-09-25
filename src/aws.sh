#!/bin/bash

# Auto complete for aws cli
if hash aws_completer 2>/dev/null; then
  complete -C "$(command -v aws_completer)" aws
fi

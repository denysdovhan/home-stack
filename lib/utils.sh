#!/bin/bash

# Check if command exists in $PATH
# USAGE:
#   home-stack::exists <command>
home-stack::exists() {
  command -v "$1" > /dev/null 2>&1
}

# Search all directories up until it finds specified file
# USAGE:
#   home-stack::lookup <command>
home-stack::lookup() {
  x=$(pwd)
  while [ "$x" != "/" ] ; do
    match=$(find "$x" -maxdepth 1 -name "$1")
    if [[ -n "$match" ]]; then
      echo "$match"
      return
    fi
    x=$(dirname "$x")
  done
}

# Load variables from environment file
# USAGE:
#   home-stack::load_vars <path>
home-stack::load_vars() {
  # shellcheck disable=SC2046
  export $(grep -v '^#' "$1" | xargs);
}

#!/bin/bash

case "$1" in
  "init")
    # shellcheck source=./init.sh
    source "$HOME_STACK_DIR/lib/init.sh"
  ;;
  "add")
    echo 'add container'
  ;;
  "server")
    # shellcheck source=./server.sh
    source "$HOME_STACK_DIR/lib/server.sh"
  ;;
  *)
    echo "uknown"
    # spinning up ui
  ;;
esac

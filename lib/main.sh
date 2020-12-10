#!/bin/bash

case "$1" in
  'init')
    source "$HOME_STACK_DIR/lib/init.sh"
  ;;
  'add')
    echo 'add container'
  ;;
  'server')
    echo 'controll server'
  ;;
  *)
    echo "uknown"
    # spinning up ui
  ;;
esac

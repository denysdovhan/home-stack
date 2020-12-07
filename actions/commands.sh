#!/bin/bash

command=$(
  whiptail --title "Home Stack" --menu --notags \
    "Choose a command to perform:" 20 78 12 -- \
    "start" "Start stack" \
    "restart" "Restart stack" \
    "stop" "Stop stack" \
    "down" "Shutdown stack" \
    "stop_all" "Stop all running container" \
    "update" "Update all containers" \
    "prune" "Delete all stopped containers and volumes" \
    3>&1 1>&2 2>&3
)

case $command in
  "start")
    # shellcheck source=./commands/start.sh
    source "$HOME_STACK_DIR/commands/start.sh"
  ;;
  "down")
    # shellcheck source=./commands/down.sh
    source "$HOME_STACK_DIR/commands/down.sh"
  ;;
  "stop")
    # shellcheck source=./commands/stop.sh
    source "$HOME_STACK_DIR/commands/stop.sh"
  ;;
  "stop_all")
    # shellcheck source=./commands/stop-all.sh
    source "$HOME_STACK_DIR/commands/stop-all.sh"
  ;;
  "restart")
    # shellcheck source=./commands/restart.sh
    source "$HOME_STACK_DIR/commands/restart.sh"
  ;;
  "update")
    # shellcheck source=./commands/update.sh
    source "$HOME_STACK_DIR/commands/update.sh"
  ;;
  "prune")
    # shellcheck source=./commands/prune.sh
    source "$HOME_STACK_DIR/commands/prune.sh"
  ;;
esac

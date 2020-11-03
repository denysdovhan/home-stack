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
    # shellcheck source=./commands/start.bash
    source "$HOME_STACK_ROOT/commands/start.bash"
  ;;
  "down")
    # shellcheck source=./commands/down.bash
    source "$HOME_STACK_ROOT/commands/down.bash"
  ;;
  "stop")
    # shellcheck source=./commands/stop.bash
    source "$HOME_STACK_ROOT/commands/stop.bash"
  ;;
  "stop_all")
    # shellcheck source=./commands/stop-all.bash
    source "$HOME_STACK_ROOT/commands/stop-all.bash"
  ;;
  "restart")
    # shellcheck source=./commands/restart.bash
    source "$HOME_STACK_ROOT/commands/restart.bash"
  ;;
  "update")
    # shellcheck source=./commands/update.bash
    source "$HOME_STACK_ROOT/commands/update.bash"
  ;;
  "prune")
    # shellcheck source=./commands/prune.bash
    source "$HOME_STACK_ROOT/commands/prune.bash"
  ;;
esac

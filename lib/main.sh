#!/bin/bash

MAIN_COMMAND="$1"

if [[ -z "$MAIN_COMMAND" ]]; then
  MAIN_COMMAND=$(whiptail --title "Home Stack" --menu --notags \
    "" 20 78 12 -- \
    "init" "Init the project" \
    "add" "Add containers" \
    "server" "Control server" \
    "backup" "Manage backups" \
    "install-ha-supervised" "Install Home Assistant Supervised" \
    "upgrade" "Update Home Stack" \
    3>&1 1>&2 2>&3
  )
fi

case "$MAIN_COMMAND" in
  "init")
    # shellcheck source=./init.sh
    source "$HOME_STACK_DIR/lib/init.sh"
  ;;
  "add")
    # shellcheck source=./add.sh
    source "$HOME_STACK_DIR/lib/add.sh"
  ;;
  "server")
    # shellcheck source=./server.sh
    source "$HOME_STACK_DIR/lib/server.sh"
  ;;
  "backup")
    # shellcheck source=./server.sh
    source "$HOME_STACK_DIR/lib/backup.sh"
  ;;
  "install-ha-supervised")
    # shellcheck source=./install-ha-supervised.sh
    source "$HOME_STACK_DIR/lib/install-ha-supervised.sh"
  ;;
  "upgrade")
    # shellcheck source=./upgrade.sh
    source "$HOME_STACK_DIR/lib/upgrade.sh"
  ;;
  *)
    # TODO: Print help info here
    echo "Uknown command"
  ;;
esac

#!/bin/bash

# Check if project exists
if [[ -z $PROJECT_DOCKER_COMPOSE ]]; then
  echo "There is not docker-compose.yaml file in current project!"
  echo "Please, intialize the project first."
  exit 1
fi

BACKUP_COMMAND="$2"

if [[ -z "$BACKUP_COMMAND" ]]; then
  BACKUP_COMMAND=$(
    whiptail --title "Home Stack" --menu --notags \
      "Choose a command to perform:" 20 78 12 -- \
      "create" "Backup now" \
      "restore" "Restore backup" \
      3>&1 1>&2 2>&3
    )
fi

case "$BACKUP_COMMAND" in
  "create" | "new" | "now")
    TIMESTAMP=$(date +"%Y-%m-%d_%H:%M:%S");
    BACKUP_FOLDER="$PROJECT_DIR/$BACKUPS";
    BACKUP_FILE="$BACKUP_FOLDER/backup-$TIMESTAMP.tag.gz";
    mkdir -p "$BACKUP_FOLDER"

    echo "Compressing $PROJECT_DIR into $BACKUP_FILE..."
    tar --exclude="$BACKUPS" -czvf "$BACKUP_FILE" "$PROJECT_DIR"

    if [[ ! -f "$BACKUP_FILE" ]]; then
      echo "Something went wrong!"
      echo "File $BACKUP_FILE was not created!"
      exit 1;
    fi

    echo "Compressed! File size: $(du -h $BACKUP_FILE)"

    echo "Removing old backups..."
    find $BACKUP_FOLDER -mtime +10 -type f -delete;
  ;;
  "restore")
    BACKUP_FILE="$3"

    if [[ ! -f "$BACKUP_FILE" ]]; then
      echo "File $BACKUP_FILE doesn't exist!"
      exit 1;
    fi

    echo "Purging all files except $BACKUPS"
    find $PROJECT_DIR -not -path "*/$BACKUPS*" -type f -delete

    tar -zxvf $BACKUP_FILE

    echo "$BACKUP_FILE restored!"
  ;;
  *)
    # TODO: Print help here
    echo "Unknown server command"
    exit 1
  ;;
esac

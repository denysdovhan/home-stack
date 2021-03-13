#!/bin/bash

BACKUP_COMMAND="$2"
BACKUP_FOLDER="$PROJECT_DIR/${BACKUPS:-.backups}";

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
    TIMESTAMP=$(date +"%Y-%m-%d_%H-%M%S");
    BACKUP_FILE="$BACKUP_FOLDER/backup_$TIMESTAMP.tar.gz";
    mkdir -p "$BACKUP_FOLDER"

    echo "Compressing $PROJECT_DIR into $BACKUP_FILE..."

    pushd "$PROJECT_DIR" > /dev/null || exit
    tar --exclude="$BACKUPS" -czvf "$BACKUP_FILE" .
    popd > /dev/null || exit

    if [[ ! -f "$BACKUP_FILE" ]]; then
      echo "Something went wrong!"
      echo "File $BACKUP_FILE was not created!"
      exit 1;
    fi

    echo "Compressed! File size: $(du -h $BACKUP_FILE)"

    echo "Removing old backups..."
    find "$BACKUP_FOLDER" -mtime +10 -type f -delete;
  ;;
  "restore")
    # Check for argument
    if [[ -n "$3" ]]; then
      BACKUP_FILE="$3"
    fi

    # If argument is not present, then ask user
    if [[ -z "$3" ]]; then
      for file in "$BACKUP_FOLDER"/*.tar.gz; do
        if [ ! -f $file ]; then
          whiptail \
            --title "Home Stack" \
            --msgbox "No backups found. Try creating one." \
            8 78
          exit
        fi
        filename=$(basename $file)
        filesize=$(du -sh $file | cut -f1)
        created=$(date +%^b\ %-e\ %Y -r $file)

        LIST_ENTRIES+=("$filename")
        LIST_ENTRIES+=("    -    $created  [$filesize]")
      done

      SELECTED_BACKUP=$(whiptail \
        --title "Home Stack" \
        --menu "Choose a backup:" \
        20 78 12 \
        "${LIST_ENTRIES[@]}" \
        3>&1 1>&2 2>&3)

      if [[ $? != 0 ]]; then
        echo "Initialising new project is aborted by the user"
        exit
      fi

      BACKUP_FILE="$BACKUP_FOLDER/$SELECTED_BACKUP"
    fi

    if [[ ! -f "$BACKUP_FILE" ]]; then
      echo "File $BACKUP_FILE doesn't exist!"
      exit 1;
    fi

    if (whiptail \
      --title "Restoring a backup" \
      --yesno "Everything will be erased. The content of this backup will be restored. Are you sure?" \
      20 78);
    then
      echo "Restoring $BACKUP_FILE..."

      echo "Purging all files except for $BACKUP_FOLDER..."
      pushd "$PROJECT_DIR" > /dev/null || exit
      find . -not -path "$BACKUP_FOLDER/*" -delete

      tar -zxvf "$BACKUP_FILE" "$PROJECT_DIR"
      popd > /dev/null || exit
    fi
  ;;
  *)
    # TODO: Print help here
    echo "Unknown backup command"
    exit 1
  ;;
esac

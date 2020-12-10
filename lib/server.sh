#!/bin/bash

SERVER_COMMAND="$2"

if [[ -z "$SERVER_COMMAND" ]]; then
  SERVER_COMMAND=$(
    whiptail --title "Home Stack" --menu --notags \
      "Choose a command to perform:" 20 78 12 -- \
      "start" "Start stack" \
      "restart" "Restart stack" \
      "stop" "Stop stack" \
      "down" "Shutdown stack" \
      "stop-all" "Stop all running container" \
      "update" "Update all containers" \
      "prune" "Delete all stopped containers and volumes" \
      3>&1 1>&2 2>&3
    )
fi

case "$SERVER_COMMAND" in
  "up" | "start")
    echo "Starting containers..."
    docker-compose up -d
  ;;
  "down" | "shutdown")
    echo "Stopping and removing containers..."
    docker-compose down
  ;;
  "stop")
    echo "Stopping containers..."
    docker-compose stop
  ;;
  "stop-all")
    echo "Stoping all running containers..."
    docker container stop "$(docker container ls -aq)"
  ;;
  "restart")
    echo "Restarting containers..."
    docker-compose restart
  ;;
  "update")
      echo "Stopping containers..."
      docker-compose down
      echo "Pulling latest images..."
      docker-compose pull
      echo "Building images..."
      docker-compose build
      echo "Starting containers..."
      docker-compose up -d
      echo "Consider running prune-images to free up space..."
  ;;
  "prune")
    echo "Deletting all images not associated with a container..."
    docker image prune -a
  ;;
  *)
    # TODO: Print help here
    echo "Unknown server command"
    exit 1
  ;;
esac

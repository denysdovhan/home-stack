#!/bin/bash

declare -A containers=(
  [portainer-ce]="Portainer CE"
  [plex]="Plex Media Server"
  # TODO:
  #   zigbee2mqtt
  #   home-assistant-docker
)

# 'docker-compose.y*ml' matches both .yml and .yaml extensions
DOCKER_COMPOSE=$(home-stack::lookup docker-compose.y*ml)
PROJECT_ROOT=$(dirname "$DOCKER_COMPOSE")

if [[ -z $DOCKER_COMPOSE ]]; then
  PROJECT_ROOT=$(whiptail \
    --title "Home Stack" \
    --inputbox "The root folder for your Home Stack configuration (current directory by default):" \
    10 60 $PWD 3>&1 1>&2 2>&3)

  if [[ $? = 0 ]]; then
    rsync -a -q "$HOME_STACK_ROOT/templates/" "$PROJECT_ROOT/"

    DOCKER_COMPOSE="$PROJECT_ROOT/docker-compose.yaml"

    whiptail \
      --title "Home Stack" \
      --msgbox "docker-compose.yaml and .env files has been created in $PROJECT_ROOT" \
      10 60
  else
    echo "Building containers aborted by user."
  fi
fi

# Building list of entries for whiptail menu
for key in "${!containers[@]}"; do
  list_entries+=("$key")
  list_entries+=("${containers[$key]}")

  # Check if docker-compose contains the container's key
  if grep -q "$key" "$DOCKER_COMPOSE"; then
    list_entries+=("ON")
  else
    list_entries+=("OFF")
  fi
done

selected_containers=$(whiptail \
  --title "Home Stack" \
  --notags --separate-output --checklist \
  "Check containers you want to add to your docker-compose.yaml" \
  20 78 12 -- "${list_entries[@]}" 3>&1 1>&2 2>&3)

if [[ -n "$selected_containers" ]]; then
  mapfile -t containers_to_install <<< "$selected_containers"

  echo "${containers_to_install[@]}"

  for container in "${containers_to_install[@]}"; do
    if grep -q "$container" "$DOCKER_COMPOSE"; then
      echo "$container is already installed"
      continue;
    fi

    echo "Adding $container container..."

    # TODO: Add install script for each container
    cat "$HOME_STACK_ROOT/containers/$container/container.yaml" >> "$DOCKER_COMPOSE"

    if [[ -f "$HOME_STACK_ROOT/containers/$container/.env" ]]; then
      echo "" >> "$PROJECT_ROOT/.env"
      cat "$HOME_STACK_ROOT/containers/$container/.env" >> "$PROJECT_ROOT/.env"
    fi
  done

  # TODO: Spin up those containers
else
  echo "Build is cancelled"
fi

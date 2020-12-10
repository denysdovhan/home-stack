#!/bin/bash

declare -A containers=(
  [portainer-ce]="Portainer CE"
  [plex]="Plex Media Server"
  # TODO:
  #   zigbee2mqtt
  #   home-assistant-docker
)

if [[ -z $DOCKER_COMPOSE ]]; then
  PROJECT_DIR=$(whiptail \
    --title "Home Stack" \
    --inputbox "The root folder for your Home Stack configuration (current directory by default):" \
    10 60 $PWD 3>&1 1>&2 2>&3)

  if [[ $? = 0 ]]; then
    # Copy templates to a future project root
    rsync -a -q "$HOME_STACK_DIR/templates/" "$PROJECT_DIR/"

    DOCKER_COMPOSE="$PROJECT_DIR/docker-compose.yaml"

    whiptail \
      --title "Home Stack" \
      --msgbox "docker-compose.yaml and .env files has been created in $PROJECT_DIR" \
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

    container_dir="$HOME_STACK_DIR/containers/$container"

    # TODO: Add install script for each container

    # Add container to docker-compose
    cat "$container_dir/container.yaml" >> "$DOCKER_COMPOSE"

    # Add env file
    # if [[ -f "$container_dir/.env" ]]; then
    #   if [[ ! -d "$PROJECT_DIR/$container" ]]; then
    #     mkdir "$PROJECT_DIR/$container"
    #   fi
    #   cat "$container_dir/.env" >> "$PROJECT_DIR/env/$container.env"
    # fi

    # Execute postinstall script
    [[ -f "$container_dir/install.sh" ]] && source "$container_dir/install.sh"
  done

  # TODO: Spin up those containers
else
  echo "Build is cancelled"
fi

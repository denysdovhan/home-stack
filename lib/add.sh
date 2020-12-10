#!/bin/bash

declare -A CONTAINERS=(
  [portainer-ce]="Portainer CE"
  [plex]="Plex Media Server"
  [zigbee2mqtt]="zigbee2mqtt"
  # TODO:
  #   home-assistant-docker
)

CONTAINERS_TO_INSTALL=

# Check if project exists
if [[ -z $PROJECT_DOCKER_COMPOSE ]]; then
  echo "There is not docker-compose.yaml file in current project!"
  echo "Please, intialize the project first."
  exit 1
fi

# Validate arguments
for argument in ${*:2}; do
  if [[ "${CONTAINERS[$argument]}" ]]; then
    CONTAINERS_TO_INSTALL+="$argument"
  else
    echo "Container $argument does not exist!"
    exit 1
  fi
done

# If not containers provided as arguments, then show the menu
if [[ -z "${CONTAINERS_TO_INSTALL[*]}" ]]; then
  # Building list of entries for whiptail menu
  for key in "${!CONTAINERS[@]}"; do
    LIST_ENTRIES+=("$key")
    LIST_ENTRIES+=("${CONTAINERS[$key]}")

    # Check if docker-compose contains the container's key
    if grep -q "$key" "$PROJECT_DOCKER_COMPOSE"; then
      LIST_ENTRIES+=("ON")
    else
      LIST_ENTRIES+=("OFF")
    fi
  done

  # shellcheck disable=SC2178
  SELECTED_CONTAINERS=$(whiptail \
    --title "Home Stack" \
    --notags --separate-output --checklist \
    "Check containers you want to add to your docker-compose.yaml" \
    20 78 12 -- \
    "${LIST_ENTRIES[@]}" \
    3>&1 1>&2 2>&3
  )

  if [[ -n "$SELECTED_CONTAINERS" ]]; then
    mapfile -t CONTAINERS_TO_INSTALL <<< "$SELECTED_CONTAINERS"
  fi
fi

# Install containers
if [[ -n "${CONTAINERS_TO_INSTALL[*]}" ]]; then
  for container in "${CONTAINERS_TO_INSTALL[@]}"; do
    if grep -q "$container" "$PROJECT_DOCKER_COMPOSE"; then
      continue;
    fi

    echo "Adding $container container..."

    CONTAINER_DIR="$HOME_STACK_DIR/containers/$container"

    # Add container to docker-compose
    cat "$CONTAINER_DIR/container.yaml" >> "$PROJECT_DOCKER_COMPOSE"

    # Concat environment
    if [[ -f "$CONTAINER_DIR/.env" ]]; then
      cat "$CONTAINER_DIR/.env" >> "$PROJECT_DIR/.env"
    fi

    # Execute postinstall script
    if [[ -f "$CONTAINER_DIR/install.sh" ]]; then
      # shellcheck disable=SC1090
      source "$CONTAINER_DIR/install.sh"
    fi
  done
else
  echo "Adding containers is canceled"
fi

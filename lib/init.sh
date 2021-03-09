#!/bin/bash

SHOULD_REBOOT=

# Install docker
if home-stack::exists docker; then
  echo "docker is already installed"
else
  echo "Installing Docker..."
  curl -fsSL https://get.docker.com | sh
  sudo usermod -G docker -a $USER
  sudo usermod -G bluetooth -a $USER
  SHOULD_REBOOT=true
fi

# Install docker-compose
if home-stack::exists docker-compose; then
  echo "docker-compose is already installed"
else
  echo "Installing docker-compose..."
  sudo apt install -y docker-compose
  SHOULD_REBOOT=true
fi

# Generating new project from templates
if [[ -z $PROJECT_DOCKER_COMPOSE ]]; then
  NEW_PROJECT_DIR=""

  # Check for argument
  if [[ -n "$2" ]]; then
    NEW_PROJECT_DIR="$2"
  fi

  # If argument is not present, then ask user
  if [[ -z "$2" ]]; then
    NEW_PROJECT_DIR=$(whiptail \
      --title "Home Stack" \
      --inputbox "The root folder for your Home Stack configuration (current directory by default):" \
      10 60 \
      $PWD \
      3>&1 1>&2 2>&3)

    if [[ $? != 0 ]]; then
      echo "Initialising new project is aborted by the user"
      exit
    fi
  fi

  if [[ ! -d "$NEW_PROJECT_DIR" ]]; then
    echo "Directory $NEW_PROJECT_DIR does not exist"
    echo "Creating directory $NEW_PROJECT_DIR"
    mkdir -p "$NEW_PROJECT_DIR"
  fi

  echo "Generating new project in $NEW_PROJECT_DIR"

  # Scaffold the project

  HOME_STACK_PUID="$(id -u)"
  HOME_STACK_PGID="$(id -g)"
  HOME_STACK_TZ="$(cat /etc/timezone)"

  export HOME_STACK_PUID
  export HOME_STACK_PGID
  export HOME_STACK_TZ

  cat "$HOME_STACK_DIR/templates/.env.template" | envsubst > "$NEW_PROJECT_DIR/.env"

  cp "$HOME_STACK_DIR/templates/.gitignore.template" "$NEW_PROJECT_DIR/.gitignore"
  cp "$HOME_STACK_DIR/templates/docker-compose.yaml.template" "$NEW_PROJECT_DIR/docker-compose.yaml"

  unset HOME_STACK_PUID
  unset HOME_STACK_PGID
  unset HOME_STACK_TZ
else
  echo "$PROJECT_DOCKER_COMPOSE exists in the project root."
  echo "Please, delete this file if you want it to be regenerated."
fi

# Ask for reboot, if needed
if [ -n "$SHOULD_REBOOT" ]; then
  if (whiptail \
    --title "Restart Required" \
    --yesno "It is recommended to restart your device. Reboot now?" \
    20 78);
  then
    sudo reboot
  fi
fi

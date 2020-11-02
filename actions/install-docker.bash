#!/bin/bash

# Check if docker and docker-compose are installed
if home-stack::exists docker && home-stack::exists docker-compose; then
  whiptail \
    --title "Home Stack" \
    --msgbox "Docker and docker-compose are already installed. Choose Ok to exit." \
    10 60
  exit
fi

# Install docker
if home-stack::exists docker; then
  echo "docker is already installed"
else
  echo "Installing Docker..."
  curl -fsSL https://get.docker.com | sh
  sudo usermod -G docker -a $USER
  sudo usermod -G bluetooth -a $USER
fi

# Install docker-compose
if home-stack::exists docker-compose; then
  echo "docker-compose is already installed"
else
  echo "Installing docker-compose..."
  sudo apt install -y docker-compose
fi

# Ask for reboot
if (whiptail \
  --title "Restart Required" \
  --yesno "It is recommended to restart your device. Reboot now?" \
  20 78);
then
  sudo reboot
fi


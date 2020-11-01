#!/bin/bash

# Installing dependencies
echo "Installing dependencies..."
sudo apt update
sudo apt install -y bash jq curl avahi-daemon dbus aaparmor network-manager

machine=$(whiptail --title "Machine type" --radiolist \
    "Please select you machine type:" 20 78 12 -- \
    "raspberrypi4" " " "ON" \
    "raspberrypi3" " " "OFF" \
    "raspberrypi2" " " "OFF" \
    "raspberrypi4-64" " " "OFF" \
    "raspberrypi3-64" " " "OFF" \
    "qemux86" " " "OFF" \
    "qemux86-64" " " "OFF" \
    "qemuarm" " " "OFF" \
    "qemuarm-64" " " "OFF" \
    "orangepi-prime" " " "OFF" \
    "odroid-xu" " " "OFF" \
    "odroid-c2" " " "OFF" \
    "intel-nuc" " " "OFF" \
    "tinker" " " "OFF" \
    3>&1 1>&2 2>&3)

if [ -n "$machine" ]; then
  curl -sL https://raw.githubusercontent.com/home-assistant/supervised-installer/master/installer.sh | sudo bash -s -- -m $machine
else
  echo "Installation of Home Assistant Supervised is canceled"
  exit
fi

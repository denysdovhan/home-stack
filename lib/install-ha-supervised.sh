#!/bin/bash

MACHINE="$2"

if [[ -z "$MACHINE" ]]; then
  MACHINE=$(whiptail --title "Machine type" --menu \
    "Please select you machine type:" 20 78 12 -- \
    "raspberrypi4" " " \
    "raspberrypi3" " " \
    "raspberrypi2" " " \
    "raspberrypi4-64" " " \
    "raspberrypi3-64" " " \
    "qemux86" " " \
    "qemux86-64" " " \
    "qemuarm" " " \
    "qemuarm-64" " " \
    "orangepi-prime" " " \
    "odroid-xu" " " \
    "odroid-c2" " " \
    "intel-nuc" " " \
    "tinker" " " \
    3>&1 1>&2 2>&3
  )
fi

if [ -n "$MACHINE" ]; then
  curl -sL https://raw.githubusercontent.com/home-assistant/supervised-installer/master/installer.sh | sudo bash -s -- -m $MACHINE
else
  echo "Installation of Home Assistant Supervised is canceled"
  exit
fi

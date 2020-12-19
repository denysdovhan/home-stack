#!/bin/bash

if [[ ! -d "$PROJECT_DIR/mosquitto" ]]; then
  mkdir -p "$PROJECT_DIR/mosquitto"
fi

cp "$CONTAINER_DIR/filter.acl" "$PROJECT_DIR/mosquitto/filter.acl"
cp "$CONTAINER_DIR/mosquitto.conf" "$PROJECT_DIR/mosquitto/mosquitto.conf"

echo "IMPORTANT:"
echo "IMPORTANT: Your Mosquitto instance is not sequred!"
echo "IMPORTANT: You should set password for Mosquitto. To do so, execute:"
echo "IMPORTANT: $ home-stack server up"
echo "IMPORTANT: $ docker exec -it mosquitto sh"
echo "IMPORTANT: $ mosquitto_passwd -c /mosquitto/data/users.db mqtt"
echo "IMPORTANT: $ exit"
echo "IMPORTANT:"
echo "IMPORTANT: Then you should uncomment 'password_file' option in mosquitto.conf file."
echo "IMPORTANT: Don't forget to restart server after that."

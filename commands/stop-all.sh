#!/bin/bash

echo "Stoping all running containers..."

docker container stop "$(docker container ls -aq)"

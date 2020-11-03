#!/bin/bash

echo "Deletting all images not associated with a container..."

docker image prune -a

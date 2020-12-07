#!/bin/bash

echo "Stopping containers..."
docker-compose down

echo "Pulling latest images..."
docker-compose pull

echo "Building images..."
docker-compose build

echo "Starting containers..."
docker-compose up -d

echo "Consider running prune-images to free up space..."

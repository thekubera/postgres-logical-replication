#!/bin/bash
echo "Starting source_service..."
cd source_service && docker compose up -d
echo "Starting target_service..."
cd ../target_service && docker compose up -d
echo "All services started! Check status with ./status.sh"
#!/bin/bash
echo "Stopping target_service..."
cd target_service && docker compose down
echo "Stopping source_service..."
cd ../source_service && docker compose down
echo "All services stopped."
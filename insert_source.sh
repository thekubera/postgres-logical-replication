#!/bin/bash
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: ./insert_source.sh <name> <email>"
  echo "Example: ./insert_source.sh 'Bob' 'bob@example.com'"
  exit 1
fi
docker exec -it source_service-source_db-1 psql -U postgres -d source_db -c "INSERT INTO users (name, email) VALUES ('$1', '$2');"
echo "Inserted into source_db: $1, $2"
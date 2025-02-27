#!/bin/bash
echo "Target 1:"
docker exec -it target_service-target_db-1 psql -U postgres -d target_db -c "SELECT * FROM users;"
echo "Target 2:"
docker exec -it target_service-target_db_2-1 psql -U postgres -d target_db_2 -c "SELECT * FROM users;"
echo "Target Missing:"
docker exec -it target_service-target_db_missing-1 psql -U postgres -d target_db_missing -c "SELECT * FROM users;"
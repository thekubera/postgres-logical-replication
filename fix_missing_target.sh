#!/bin/bash
docker exec -it target_service-target_db_missing-1 psql -U postgres -d target_db_missing -c "ALTER TABLE users ADD COLUMN email VARCHAR(255);"
docker exec -it target_service-target_db_missing-1 psql -U postgres -d target_db_missing -c "ALTER SUBSCRIPTION users_sub_missing REFRESH PUBLICATION WITH (copy_data = true);"
echo "Missing target fixed and data should be synced"
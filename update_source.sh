#!/bin/bash
docker exec -it source_service-source_db-1 psql -U postgres -d source_db -c "UPDATE users SET name = name || '_updated' WHERE email LIKE '%example.com';"
echo "Updated rows in source_db. Check targets with ./check_target.sh"
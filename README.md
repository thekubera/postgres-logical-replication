# PostgreSQL Logical Replication Across Services

This project demonstrates **database-level replication** between two PostgreSQL databases using its native **publish/subscribe** feature—no app logic or external tools like Kafka required! It simulates two services (`source_service` and `target_service`) where changes in one database (`source_db`) automatically sync to another (`target_db`). Perfect for services needing shared, real-time data without business logic overhead.

## What You’ll Learn
- How PostgreSQL’s logical replication works.
- Setting up replication between two databases in Docker.
- Using separate `docker-compose` files for service-style isolation.
- Testing real-time data sync without writing code.

## Prerequisites
- Docker and Docker Compose installed.
- Basic terminal skills.

## Project Structure
- `source_service/`: The publisher service with `source_db`.
  - `docker-compose.yml`: Runs PostgreSQL 17 with a publication.
  - `source-init.sql`: Creates the `users` table and `users_pub` publication.
- `target_service/`: The subscriber service with `target_db`.
  - `docker-compose.yml`: Runs PostgreSQL 17 with a subscription.
  - `target-init.sql`: Sets up the `users` table and subscribes to `source_db`.

## Setup Steps

### 1. Clone the Repo
```bash
git clone https://github.com/thekubera/postgres-logical-replication
cd postgres-logical-replication
```

### 2. Create a Shared Network
Both services need to talk over the same network:
```bash
docker network create replication_net
```

### 3. Start the Source Service
The publisher (`source_db`) comes first:
```bash
cd source_service
docker compose up -d
```
- Creates a `users` table with initial data (Alice).
- Sets up the `users_pub` publication.

### 4. Start the Target Service
The subscriber (`target_db`) connects to `source_db`:
```bash
cd ../target_service
docker compose up -d
```
- Creates a `users` table.
- Subscribes to `users_pub` via `users_sub`.

## Test It Out
Let’s see replication in action!

### 1. Check Initial Data
In `source_db`:
```bash
docker exec -it source_service-source_db-1 psql -U postgres -d source_db -c "SELECT * FROM users;"
```
Output: Alice (ID 1).

In `target_db`:
```bash
docker exec -it target_service-target_db-1 psql -U postgres -d target_db -c "SELECT * FROM users;"
```
Output: Alice (synced!).

### 2. Add New Data
Insert a row in `source_db`:
```bash
docker exec -it source_service-source_db-1 psql -U postgres -d source_db -c "INSERT INTO users (name, email) VALUES ('Bob', 'bob@example.com');"
```

Check `target_db`:
```bash
docker exec -it target_service-target_db-1 psql -U postgres -d target_db -c "SELECT * FROM users;"
```
Output: Alice and Bob—magic!

### 3. Update Data
Update in `source_db`:
```bash
docker exec -it source_service-source_db-1 psql -U postgres -d source_db -c "UPDATE users SET name = 'Bob Updated' WHERE email = 'bob@example.com';"
```

Check `target_db`:
```bash
docker exec -it target_service-target_db-1 psql -U postgres -d target_db -c "SELECT * FROM users;"
```
Output: Alice and Bob Updated.

## How It Works
- **Publisher (`source_db`)**: Uses `wal_level=logical` and a publication (`users_pub`) to stream changes from the `users` table.
- **Subscriber (`target_db`)**: Uses a subscription (`users_sub`) to pull changes from `source_db` over the `replication_net` network.
- **Docker**: Runs each service in isolated containers, mimicking services on different servers.

## Troubleshooting
- **“Could not translate host name”**: Ensure both services are on `replication_net` (`docker network inspect replication_net`).
- **“Max WAL senders” error**: `max_wal_senders` and `max_replication_slots` are set to 2 in `source_service` to handle initial sync and ongoing replication.
- **No data in `target_db`**: Check logs (`docker compose logs`) and subscription status:
```bash
docker exec -it target_service-target_db-1 psql -U postgres -d target_db -c "SELECT * FROM pg_stat_subscription;"
```

## Stop the Services
```bash
cd source_service
docker compose down
cd ../target_service
docker compose down
```


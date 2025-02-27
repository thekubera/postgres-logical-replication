CREATE EXTENSION IF NOT EXISTS dblink;

DO $$
BEGIN
    PERFORM dblink_exec('host=source_db port=5432 dbname=source_db user=postgres password=password', 
                        'SELECT pg_drop_replication_slot(''users_sub_2'') 
                         FROM pg_replication_slots 
                         WHERE slot_name = ''users_sub_2'' AND active = false');
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Slot users_sub_2 drop failed or not needed: %', SQLERRM;
END;
$$;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255)
);

CREATE SUBSCRIPTION users_sub_2
    CONNECTION 'host=source_db port=5432 dbname=source_db user=postgres password=password'
    PUBLICATION users_pub;
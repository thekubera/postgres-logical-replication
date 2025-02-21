CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255)
);
CREATE SUBSCRIPTION users_sub
    CONNECTION 'host=source_db port=5432 dbname=source_db user=postgres password=password'
    PUBLICATION users_pub;
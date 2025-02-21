CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255)
);
INSERT INTO users (name, email) VALUES ('Alice', 'alice@example.com');
CREATE PUBLICATION users_pub FOR TABLE users;
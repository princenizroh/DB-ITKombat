-- migrate:up
CREATE TABLE player (
    player_id SERIAL PRIMARY KEY NOT NULL,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL ,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- migrate:down
DROP TABLE IF EXISTS players CASCADE;

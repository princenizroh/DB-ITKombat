CREATE TABLE items (
    item_id SERIAL PRIMARY KEY,
    item_name VARCHAR(50) NOT NULL,
    item_category VARCHAR(50) NOT NULL,
    item_subtype VARCHAR(50) NOT NULL,
    item_price INT NOT NULL,
    is_tradeable BOOLEAN NOT NULL,
    item_description TEXT,
    obtainable_from VARCHAR(50) NOT NULL
);

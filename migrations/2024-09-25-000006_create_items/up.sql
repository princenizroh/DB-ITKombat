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

INSERT INTO items (item_name, item_category, item_subtype, item_price, is_tradeable, item_description, obtainable_from)
VALUES 
('Health Potion', 'Consumable', 'Potion', 50, TRUE, 'Restores 50 HP', 'Store'),
('Mana Potion', 'Consumable', 'Potion', 40, TRUE, 'Restores 50 MP', 'Store'),
('Iron Sword', 'Weapon', 'Sword', 200, FALSE, 'Basic sword for beginners', 'Quest Reward');


CREATE TABLE player_item (
    player_item_id SERIAL PRIMARY KEY,
    quantity INT NOT NULL,
    obtained_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_equipped BOOLEAN NOT NULL,
    is_used BOOLEAN NOT NULL,
    player_id INT,
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    item_id INT,
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);

INSERT INTO player_items (quantity, is_equipped, is_used, player_id, item_id)
VALUES 
(10, FALSE, FALSE, 1, 1),
(5, TRUE, FALSE, 2, 2),
(3, TRUE, TRUE, 3, 3);


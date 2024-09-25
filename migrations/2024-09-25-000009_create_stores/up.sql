CREATE TABLE stores (
  store_id SERIAL PRIMARY KEY,
  product_id INT NOT NULL,
  product_type VARCHAR(20) NOT NULL,
  stock INT DEFAULT NULL,
  player_id INT,
  FOREIGN KEY (product_id) REFERENCES items(item_id),
  FOREIGN KEY (product_id) REFERENCES gears(gear_id),
  FOREIGN KEY (product_id) REFERENCES characters(character_id),
  FOREIGN KEY (player_id) REFERENCES players(player_id)
) 

INSERT INTO stores (product_id, product_type, stock, player_id)
VALUES 
(1, 'Item', 100, 1),
(2, 'Gear', 50, 2),
(3, 'Character', 10, 3);


CREATE TABLE stores (
  store_id SERIAL PRIMARY KEY,
  product_id INT NOT NULL,
  product_type VARCHAR(20) NOT NULL,
  stock INT DEFAULT NULL,
  balance INT,
  player_id INT,
  FOREIGN KEY (product_id) REFERENCES items(item_id),
  FOREIGN KEY (product_id) REFERENCES gears(gear_id),
  FOREIGN KEY (product_id) REFERENCES characters(character_id),
  FOREIGN KEY (balance_id) REFERENCES players(balance_id),
  FOREIGN KEY (player_id) REFERENCES players(player_id)
) 

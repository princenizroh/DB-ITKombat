CREATE TABLE gears (
    gear_id SERIAL PRIMARY KEY,
    gear_name VARCHAR(50) NOT NULL,
    gear_type VARCHAR(50) NOT NULL,
    gear_exp INT NOT NULL,
    gear_price INT NOT NULL,
    gear_grade VARCHAR(50),
    gear_description TEXT,
    base_atack INT,
    base_defense INT,
    base_intelligence INT,
    obtained_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    character_id INT,
    player_id INT,
    FOREIGN KEY (character_id) REFERENCES characters(character_id),
    FOREIGN KEY (player_id) REFERENCES players(player_id)
  );

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

  INSERT INTO gears (gear_name, gear_type, gear_exp, gear_price, gear_grade, gear_description, base_attack, base_defense, base_intelligence, character_id, player_id)
VALUES 
('Sword of Valor', 'Weapon', 100, 5000, 'A', 'A powerful sword with high attack power', 50, 20, 15, 1, 1),
('Shield of Guardians', 'Armor', 150, 3000, 'B', 'A sturdy shield for defense', 10, 60, 5, 2, 2),
('Magic Staff', 'Weapon', 200, 7000, 'S', 'A staff imbued with magical powers', 20, 10, 50, 3, 3);


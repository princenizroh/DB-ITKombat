CREATE TABLE characters (
    character_id SERIAL PRIMARY KEY,
    character_name VARCHAR(50) NOT NULL,
    character_type VARCHAR(50) NOT NULL,
    character_price INT NOT NULL,
    character_grade VARCHAR(50) NOT NULL,
    base_attack INT,
    base_defense INT,
    base_intelligence INT,
    player_id INT,
    FOREIGN KEY (player_id) REFERENCES players(player_id)
);

INSERT INTO characters (character_name, character_type, character_price, character_grade, base_attack, base_defense, base_intelligence, player_id)
VALUES 
('Warrior', 'Melee', 5000, 'A', 60, 30, 20, 1),
('Mage', 'Magic', 7000, 'S', 30, 20, 70, 2),
('Archer', 'Ranged', 6000, 'A', 50, 25, 35, 3);


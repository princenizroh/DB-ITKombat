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

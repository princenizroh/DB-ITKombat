CREATE TABLE enchances(
    enchance_id SERIAL PRIMARY KEY,
    experience_gaint INT NOT NULL,
    upgrade_stat_attack INT NOT NULL,
    upgrade_stat_defense INT NOT NULL,
    upgrade_stat_speed INT NOT NULL,
    upgrade_stat_inteligence INT NOT NULL,
    result VARCHAR(20) NOT NULL,
    upgrade_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    player_id INT,
    gear_id INT,
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (gear_id) REFERENCES gears(gear_id)
);

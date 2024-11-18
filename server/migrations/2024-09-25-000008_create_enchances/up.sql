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

INSERT INTO enchances (experience_gain, upgrade_stat_attack, upgrade_stat_defense, upgrade_stat_speed, upgrade_stat_intelligence, result, player_id, gear_id)
VALUES 
(100, 5, 3, 2, 1, 'Success', 1, 1),
(200, 10, 5, 3, 2, 'Success', 2, 2),
(150, 8, 4, 2, 3, 'Failure', 3, 3);


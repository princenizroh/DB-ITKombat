CREATE TABLE login_history (
    login_history_id SERIAL PRIMARY KEY,
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    logout_time TIMESTAMP,
    login_data VARCHAR(255),
    player_id INT REFERENCES Player(player_id) ON DELETE CASCADE
);

INSERT INTO login_history (player_id, login_data, login_time)
VALUES 
(1, 'Logged in via Web', '2024-09-25 10:00:00'),
(2, 'Logged in via Mobile', '2024-09-25 11:30:00'),
(3, 'Logged in via Web', '2024-09-25 12:45:00');



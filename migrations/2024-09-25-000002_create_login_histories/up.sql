CREATE TABLE login_histories (
    login_history_id SERIAL PRIMARY KEY,
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    logout_time TIMESTAMP,
    login_data VARCHAR(255),
    player_id INT REFERENCES Player(player_id) ON DELETE CASCADE
);


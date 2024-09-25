CREATE TABLE login_history (
    login_history_id SERIAL PRIMARY KEY,
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    logout_time TIMESTAMP,
    login_data VARCHAR(255),
    player_id INT REFERENCES players(player_id) ON DELETE CASCADE
);

-- Stored Procedure untuk menambah data ke tabel login_histories
CREATE OR REPLACE PROCEDURE add_player_history(p_player_id INT, p_login_data VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO login_history (player_id, login_data)
    VALUES (p_player_id, p_login_data);
END;
$$;


-- Data awal
INSERT INTO login_history (player_id, login_data)
VALUES 
(1, 'Logged in via Android'),
(2, 'Logged in via Web');


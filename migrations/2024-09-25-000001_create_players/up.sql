CREATE TABLE players (
    player_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(50) NOT NULL,
    favourite_animal VARCHAR(50),
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Stored Procedure untuk menambah data ke tabel login_histories
CREATE OR REPLACE PROCEDURE add_player_history(p_player_id INT, p_login_data TIMESTAMP)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO login_histories (player_id, login_data)
    VALUES (p_player_id, p_login_data);
END;
$$;

-- Function untuk memeriksa duplikat username di tabel players
CREATE OR REPLACE FUNCTION check_duplicate_player() RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM players WHERE username = NEW.username) THEN
        RAISE EXCEPTION 'Player with username % already exists', NEW.username;
    END IF;
    RETURN NEW;
END;
$$;

-- Trigger untuk memeriksa duplikat username sebelum insert di tabel players
CREATE TRIGGER before_insert_player
BEFORE INSERT ON players
FOR EACH ROW
EXECUTE FUNCTION check_duplicate_player();

INSERT INTO players (username, email, password, favourite_animal)
VALUES 
('PlayerOne', 'playerone@example.com', 'password123', 'Dog'),
('PlayerTwo', 'playertwo@example.com', 'password456', 'Cat'),
('PlayerThree', 'playerthree@example.com', 'password789', 'Dragon');


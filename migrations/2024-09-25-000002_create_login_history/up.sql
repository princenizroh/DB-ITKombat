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

BEGIN;  -- Memulai transaksi

-- Memanggil stored procedure untuk menambah data ke login_history
CALL add_player_history(1, 'Logged in via Mobile');
CALL add_player_history(2, 'Logged in via Web');

-- Commit transaksi jika semua operasi sukses
COMMIT;

-- Jika ada error, rollback transaksi
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE NOTICE 'Terjadi error, transaksi di-rollback';
END;



-- Data awal
INSERT INTO login_history (player_id, login_data)
VALUES 
(1, 'Logged in via Android'),
(2, 'Logged in via Web');


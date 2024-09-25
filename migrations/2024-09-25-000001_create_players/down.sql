-- Menghapus trigger sebelum menghapus tabel players
DROP TRIGGER IF EXISTS before_insert_player ON players;

-- Menghapus function yang digunakan oleh trigger
DROP FUNCTION IF EXISTS check_duplicate_player();

-- Menghapus stored procedure yang menambah data ke login_histories
DROP PROCEDURE IF EXISTS add_player_history(INT, TIMESTAMP);

-- Menghapus tabel players
DROP TABLE IF EXISTS players CASCADE;


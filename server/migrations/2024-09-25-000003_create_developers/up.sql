CREATE TABLE developers (
    developer_id SERIAL PRIMARY KEY,
    announcement_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    announcement_data TEXT,
    login_history_id INT REFERENCES Login_history(login_history_id) ON DELETE CASCADE
);

INSERT INTO developers (announcement_data, login_history_id)
VALUES 
('New feature added: Battle mode', 1),
('Bug fix for login issue', 2),
('New update available: Version 1.1', 3);


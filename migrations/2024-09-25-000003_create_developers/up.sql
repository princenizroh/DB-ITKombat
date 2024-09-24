CREATE TABLE developers (
    developer_id SERIAL PRIMARY KEY,
    announcement_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    announcement_data TEXT,
    login_history_id INT REFERENCES Login_history(login_history_id) ON DELETE CASCADE
);


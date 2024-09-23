CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,  
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    animal_favorite VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT current_timestamp
);

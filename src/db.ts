import { Client } from 'pg';

export const createDb = async () => {
    console.log("Connectinog to PostgreSQL database...");
    const client = new Client({
        user: 'postgres',
        host: 'localhost',
        database: 'ITKombat',
        password: '3232',
        port: 5432,
    });

    await client.connect();
    console.log("Connected to PostgreSQL database!");
    
    // await client.query(`
    //   CREATE TABLE Player (
    //       player_id SERIAL PRIMARY KEY,
    //       username VARCHAR(50) NOT NULL,
    //       email VARCHAR(50) NOT NULL UNIQUE,
    //       password VARCHAR(50) NOT NULL,
    //       favourite_animal VARCHAR(50),
    //       registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    //   );
    // `);

    // await client.query(`
    //   CREATE TABLE Profile (
    //       profile_id SERIAL PRIMARY KEY,
    //       player_id INT NOT NULL,
    //       current_exp INT DEFAULT 0,
    //       level_player VARCHAR(20) NOT NULL,
    //       rank_player VARCHAR(20),
    //       amount_skp2m INT DEFAULT 0,
    //       FOREIGN KEY (player_id) REFERENCES Player(player_id)
    //   );
    // `);
    // await client.query(`
    //   CREATE TABLE gears (
    //       gear_id SERIAL PRIMARY KEY,
    //       gear_name VARCHAR(50) NOT NULL,
    //       gear_type VARCHAR(50) NOT NULL,
    //       gear_exp INT NOT NULL,
    //       gear_price INT NOT NULL,
    //       gear_grade VARCHAR(50),
    //       gear_description TEXT,
    //       base_atack INT,
    //       base_defense INT,
    //       base_intelligence INT,
    //       obtained_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    //       character_id INT,
    //       player_id INT,
    //       FOREIGN KEY (character_id) REFERENCES characters(character_id),
    //       FOREIGN KEY (player_id) REFERENCES players(player_id)
    //   );
    // `); 
    // await client.query(`
    //   CREATE TABLE characters (
    //       character_id SERIAL PRIMARY KEY,
    //       character_name VARCHAR(50) NOT NULL,
    //       character_type VARCHAR(50) NOT NULL,
    //       character_price INT NOT NULL,
    //       character_grade VARCHAR(50) NOT NULL,
    //       base_attack INT,
    //       base_defense INT,
    //       base_intelligence INT,
    //       player_id INT,
    //       FOREIGN KEY (player_id) REFERENCES players(player_id)
    //   );
    // `);
    
    return client;
}

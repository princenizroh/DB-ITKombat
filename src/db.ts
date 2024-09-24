import { Client } from 'pg';
import { exec } from 'child_process';

// Fungsi untuk menjalankan SQL file
const runSQL = (filePath: string) => {
  exec(`psql -U postgres -d ITKombat -f ${filePath}`, (err, stdout, stderr) => {
    if (err) {
      console.error(`Error executing SQL file: ${filePath}`, err);
      return;
    }
    console.log(stdout);
    if (stderr) {
      console.error(stderr);
    }
  });
};
// Up migration
// runSQL('migrations/2024-09-25-000001_create_players/up.sql');
// runSQL('migrations/2024-09-25-000002_create_login_histories/up.sql');
// runSQL('migrations/2024-09-25-000003_create_developers/up.sql');
// runSQL('migrations/2024-09-25-000004_create_gears/up.sql');
// runSQL('migrations/2024-09-25-000005_create_characters/up.sql');
// runSQL('migrations/2024-09-25-000006_create_items/up.sql');
// runSQL('migrations/2024-09-25-000007_create_player_items/up.sql');
// runSQL('migrations/2024-09-25-000008_create_enchances/up.sql');
// runSQL('migrations/2024-09-25-000009_create_stores/up.sql');
// Down migration
// runSQL('migrations/2024-09-25-000001_create_players/down.sql');
// runSQL('migrations/2024-09-25-000002_create_login_histories/down.sql');
// runSQL('migrations/2024-09-25-000003_create_developers/down.sql');
// runSQL('migrations/2024-09-25-000004_create_gears/down.sql');
// runSQL('migrations/2024-09-25-000005_create_characters/down.sql');
// runSQL('migrations/2024-09-25-000006_create_items/down.sql');
// runSQL('migrations/2024-09-25-000007_create_player_items/down.sql');
// runSQL('migrations/2024-09-25-000008_create_enchances/down.sql');
// runSQL('migrations/2024-09-25-000009_create_stores/down.sql');

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
    return client;
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
}

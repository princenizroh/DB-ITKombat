import { Client } from 'pg';
import { spawn } from 'child_process';
import path from 'path';

const runSQL = (filePath: string) => {
  const relativePath = path.relative(process.cwd(), filePath).replace(/\\/g, '/');
  console.log(`Running SQL file at: ${relativePath}`);

  // Menjalankan perintah Docker exec untuk menjalankan file SQL dalam kontainer
  const childProcess = spawn('docker', [
    'exec', 
    'itkombat', 
    'psql', 
    '-U', 
    'prince', 
    '-d', 
    'itkombat', 
    '-f', 
    `/src/migrations/${relativePath}`
  ]);

  // Output dari proses child Docker
  childProcess.stdout.on('data', (data) => {
    console.log(`stdout: ${data}`);
  });

  childProcess.stderr.on('data', (data) => {
    console.error(`stderr: ${data}`);
  });

  childProcess.on('close', (code) => {
    if (code !== 0) {
      console.error(`Process exited with code ${code}`);
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
// runSQL('migrations/2024-09-25-000002_create_login_history/down.sql');
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
        user: 'prince',
        host: 'localhost',
        database: 'itkombat',
        password: 'admin',
        // port: 5434, // port itkombat-db-compose
        port: 5433, // port itkombat-db
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

// testConnection
const client = new Client({
    user: 'prince',
    host: 'localhost',
    database: 'itkombat',
    password: 'admin',
    // port: 5434, // port itkombat-db-compose
    port: 5433, // port itkombat-db
});

const testConnection = async () => {
    try {
        await client.connect();
        console.log("Connected to PostgreSQL database!");
        const res = await client.query('SELECT NOW()');
        console.log("Current time:", res.rows[0]);
        console.log("port: ",client.port);
    } catch (err) {
        console.error("Failed to connect to the database:", err);
    } finally {
        await client.end();
        console.log("Disconnected from PostgreSQL database.");
    }
};

testConnection();

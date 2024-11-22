import { Pool} from 'pg';

export const pool = new Pool({
    user: Bun.env.DB_USER,
    host: Bun.env.DB_HOST,
    database: Bun.env.DB_NAME,
    password: Bun.env.DB_PASS,
    // port: 5434, // port itkombat-db-compose
    port: Number(Bun.env.DB_PORT), // port itkombat-db
});

// Fungsi untuk memanggil stored procedure PostgreSQL
async function callProcedure(procName: string, params: any[]) {
  const placeholders = params.map((_, i) => `$${i+1}`).join(",");
  const query = `CALL ${procName}(${placeholders})`;
  const client = await pool.connect();
  try {
    const result = await client.query(query, params);
    return result.rows || [];
  } finally {
    client.release();
  }
}

// Fungsi untuk memanggil stored procedure PostgreSQL
async function callFunction(procName: string, params: any[] = []) {
  const placeholders = params.map((_, i) => `$${i+1}`).join(",");
  const query = `SELECT * FROM ${procName}(${placeholders})`; // Menggunakan SELECT untuk mendapatkan hasil
  const client = await pool.connect();
  try {
    const result = await client.query(query, params);
    return result.rows || [];
  } finally {
    client.release();
  }
}


// INI UNTUK YANG CONNECT
const setupDatabase = async () => {
    console.log("Connecting to PostgreSQL database...");
    await pool.connect();
    console.log("Current time:", (await pool.query('SELECT NOW()')).rows[0]);
    console.log("Connected to PostgreSQL database!");
    console.log("port: ", pool.options.port);
    return pool;
}

export { setupDatabase as SetupDatabase, callProcedure as db, callFunction as dbFunction }

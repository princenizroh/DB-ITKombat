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

// callProcedure('<name procedure>', [params]);

// Fungsi untuk memanggil Function PostgreSQL
async function callFunction(
  procName: string,
  columns: string[] = [],
  key: string | null = null,
  value: any | null = null
) {
  // Pilihan kolom (default semua kolom)
  const selectedColumns = columns.length > 0 ? columns.join(", ") : "*";

  // Tambahkan WHERE jika key dan value diberikan
  const whereClause = key && value ? `WHERE ${key} = $1` : "";

  // Create query SQL
  const query = `SELECT ${selectedColumns} FROM ${procName}() ${whereClause}`;

  const client = await pool.connect();
  try {
    const params = value !== null ? [value] : []; // Gunakan value jika ada
    const result = await client.query(query, params);
    return result.rows || [];
  } finally {
    client.release();
  }
}

// callFunction('<name function>', ['<column>'], '<key>', '<value>');

export async function callFunctionQuery(
  procName: string,
  columns: string[] = [],
  key: string | null = null,
  value: any | null = null,
  params: any [] = []
) {
  const selectedColumns = columns.length > 0 ? columns.join(", ") : "*";
  const whereClause = key && value ? `WHERE ${key} = $1` : "";
  const query = `SELECT ${selectedColumns} FROM ${procName}() ${whereClause}`;
  const client = await pool.connect();

  try {
    const queryParam = value !== null ? [value] : [];
    const result = await client.query(query, [...queryParam, ...params]);
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

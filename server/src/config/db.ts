import { Pool } from 'pg';

// db root
export const pool = new Pool({
    user: Bun.env.DB_USER,
    host: Bun.env.DB_HOST,
    database: Bun.env.DB_NAME,
    password: Bun.env.DB_PASS,
    // port: 5434, // port itkombat-db-compose
    port: Number(Bun.env.DB_PORT), // port itkombat-db port 5433
});

// db client user 
export const clientPool = new Pool({
    user: Bun.env.PB_USER,
    host: Bun.env.PB_HOST,
    database: Bun.env.PB_NAME,
    password: Bun.env.PB_PASS,
    port: Number(Bun.env.PB_PORT),
})

// Fungsi untuk memanggil stored procedure PostgreSQL
async function callProcedure(
  procName: string, 
  params: any[]
) {
  const placeholders = params.map((_, i) => `$${i+1}`).join(",");
  const query = `CALL ${procName}(${placeholders})`;
  const client = await clientPool.connect();
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
  keys: string[] = [],
  values: any[] = [],
  params: any[] = []
) {
  const selectedColumns = columns.length > 0 ? columns.join(", ") : "*";
  const whereClauses = keys.map((_, i) => `${_} = $${i + 1}`).join(" AND ");
  const whereClause = whereClauses ? `WHERE ${whereClauses}` : "";
  const query = `SELECT ${selectedColumns} FROM ${procName}() ${whereClause}`;
  const client = await clientPool.connect();

  try {
    const queryParams = [...values, ...params];
    const result = await client.query(query, queryParams);
    return result.rows || [];
  } finally {
    client.release();
  }
}

// callFunction('<name function>', ['<column>'], '<key>', '<value>');




// INI UNTUK YANG CONNECT
const setupDatabase = async () => {
    console.log("Connecting to PostgreSQL database...");
    await clientPool.connect();
    console.log("User:", (await clientPool.query('SELECT current_user')).rows[0]);
    console.log("Current time:", (await clientPool.query('SELECT NOW()')).rows[0]);
    console.log("Connected to PostgreSQL database!");
    console.log("port: ", pool.options.port);
    return pool;
}

export { setupDatabase as SetupDatabase, callProcedure as db, callFunction as dbFunction};

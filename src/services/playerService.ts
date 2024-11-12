import { Client } from 'pg';


export const getPlayers = async (db: Client) => {
    const res = await db.query('SELECT * FROM player');
    return res.rows;
};
  
export const getPlayerById = async (db: Client, id: number) => {
    const res = await db.query('SELECT * FROM players WHERE player_id = $1', [id]);
    return res.rows[0];
};

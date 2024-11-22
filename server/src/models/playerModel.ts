import { t } from "elysia"
import { db } from "@/config/db"

const playerSchema = t.Object({
  player_id: t.Number(),
  username: t.String(),
  email: t.String(),
  password: t.String(),
  role: t.Enum({ admin: 'admin', user: 'user' }),
})

export const playerLogin = t.Object({
  username: t.String({
    required: true,
    example: 'zaki'
  }),
  password: t.String({
    required: true,
    example: 'admin123',
    minLength: 8
  }),
})

export const playerRegister = t.Object({
  username: t.String({
    required: true,
    example: 'zaki'
  }),
  email: t.String({
    required: true,
    format: "email",
    example: 'zaki@gmail.com'
  }),
  password: t.String({
    required: true,
    example: 'admin123',
    minLength: 8
  }),
})

export const playerLogout = t.Object({
  username: t.String({
    required: true,
    example: 'zaki'
  }),
})

export const loginPlayer = async (username: string, password: string) => {
  await db('login', [username, password]);
}

const getPlayerById = async (player_id: number) => {
  try{
    const result = await db('getPlayerById',[player_id]);
    if(!result) {
      throw new Error('Player by Id {player_id} not found');
    }
  
  return result; // Mengembalikan hasil
  } catch (error) {
    console.error(`Error in getPlayerById: ${(error as Error).message}`);
    throw error;
  }
}

const getAdminById = async (player_id: number) => {
  await db('getAdminById',[player_id]);
}


export { playerSchema as playerModel, getPlayerById, getAdminById }

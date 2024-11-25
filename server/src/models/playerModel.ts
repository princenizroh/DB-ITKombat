import { t } from "elysia"
import { db } from "@/config/db"

const playerSchema = t.Object({
  player_id: t.Number(),
  username: t.String(),
  email: t.String(),
  password: t.String(),
  role: t.Enum({ admin: 'admin', user: 'player' }),
})

export const playerSigninSchema = t.Object({
  username: t.String({
    required: true,
    example: 'zaki'
  }),
  password: t.String({
    required: true,
    example: 'admin123',
  }),
})

export const playerSignupSchema = t.Object({
  username: t.String({
    required: true,
    example: 'zaki'
  }),
  email: t.String({
    required: true,
    example: 'zaki@gmail.com'
  }),
  password: t.String({
    required: true,
    example: 'admin123',
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

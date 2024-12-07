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


const getPlayerById = async (player_id: any) => {
  try{
    const [result] = await db('get_player_by_id',[player_id]);
    if(!result) {
      throw new Error('Player by Id {player_id} not found');
    }
  
  return result;
  } catch (error) {
    console.error(`Error in getPlayerById: ${(error as Error).message}`);
    throw error;
  }
}

const getAdminById = async (player_id: number, role: any) => {
  const result = await db('get_admin_by_id',[player_id, role]);
  return result;
}


export { playerSchema as playerModel, getPlayerById, getAdminById }

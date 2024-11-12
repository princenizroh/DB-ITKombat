import { Context } from "elysia";
import { getPlayers, getPlayerById } from "../services/playerService";

export const getAllPlayers = async (ctx: Context) => {
  try {
    const players = await getPlayers((ctx.store as any).db);
    return players;
  } catch (error) {
    console.error(error);
    return {
      message: "Failed to fetch players",
      error: (error as Error).message
    };
  }
};

export const getPlayer = async (ctx: Context) => {
  try {
    const playerId = ctx.params.id;
    const player = await getPlayerById((ctx.store as any).db, Number(playerId));
    return player;
  } catch (error) {
    console.error(error);
    return {
      message: "Failed to fetch player",
      error: (error as Error).message
    };
  }
};
import { Elysia, t } from "elysia";
import { getAllPlayers, getPlayer } from "@/controllers/playerController";

export const playerRoutes = (app: Elysia) => {
  app
    .get("/players", getAllPlayers)
    .get("/players/:id", getPlayer, {
      params: t.Object({
        id: t.Numeric()
      })
    });
};

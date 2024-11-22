import { Elysia } from "elysia";
import { jwt } from "@elysiajs/jwt";
import { getPlayerById } from "@/models/playerModel";
import { JWT_NAME } from "@/config/constant-jwt";

const isPlayerMiddleware = (app: Elysia) => {
  return app
    .use(
      jwt({
        name: JWT_NAME,
        secret: Bun.env.JWT_SECRET!,
      })
    )
    .derive(async ({ jwt, set, headers, request }) => {
      const bearer = headers.authorization?.split(' ')[1];
      // hanle if accesToken is not exist
      if (request.url.includes('/swagger')) {
        return; // Biarkan permintaan ke Swagger tanpa memeriksa token
      }
      if (!bearer) {
        set.status = 401;
        return {
          authorized: false
        }
      }
      const jwtPayload = await jwt.verify(bearer);
      if (!jwtPayload) {
        // handle if jwtPayload is not exist
        set.status = 401;
        return {
          authorized: false
        }
      }

      console.log('jwtPayload middleware', jwtPayload);

      const playerId = Number(jwtPayload.sub);
      // handle if playerId is not a valid number
      if (isNaN(playerId)) {
        set.status = 401;
        return {
          authorized: false
        }
      }
      const player = await getPlayerById(playerId);
      console.log('player', player);
      if (player === null || player === undefined) {
        set.status = 401;
        return {
          authorized: false
        }
      }
      return {
        authorized: true,
        player
      };
    })
}

export { isPlayerMiddleware }

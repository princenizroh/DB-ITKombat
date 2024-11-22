import { Elysia } from "elysia";
import { jwt } from "@elysiajs/jwt";
import { loginPlayer } from "@/models/playerModel";
import { JWT_NAME } from "@/config/constant-jwt";

const app = new Elysia();
const loggerMiddleware = () => {
  app
    .use(
      jwt({
        name: JWT_NAME,
        secret: Bun.env.JWT_SECRET!,
      })
    )
    .derive(async ({ jwt, cookie: { accesToken }, set }) => {
      // hanle if accesToken is not exist
      if (!accesToken.value) {
        set.status = 401;
        return {
          authorized: false
        }
      }

      const jwtPayload = await jwt.verify(accesToken.value);
      if (!jwtPayload) {
        // handle if jwtPayload is not exist
        set.status = 401;
        return {
          authorized: false
        }
      }

      const playerId = Number(jwtPayload.sub);
      // handle if playerId is not a valid number
      if (isNaN(playerId)) {
        set.status = 401;
        return {
          authorized: false
        }
      }
      // const player = await loginPlayer(username, password);
      // if (player === null || player === undefined) {
      //   set.status = 401;
      //   return {
      //     authorized: false
      //   }
      // }
      // return {
      //   authorized: true,
      //   player
      // };
    })
}

export { loggerMiddleware }

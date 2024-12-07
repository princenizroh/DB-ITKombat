import { Elysia } from "elysia";
import { jwt } from "@elysiajs/jwt";
import { getPlayerById } from "@/models/playerModel";
import { JWT_NAME } from "@/config/jwt";

const isPlayerMiddleware = (app: Elysia) => {
  return app
    .use(
      jwt({
        name: JWT_NAME,
        secret: Bun.env.JWT_SECRET!,
      })
    )
    .derive(async ({ jwt, set, cookie }: { jwt: any, set: any, cookie: any }) => {
      const accessTokenValue = cookie?.accessToken?.value;
      if(!accessTokenValue) {
        set.status = 401;
        return {
          success: false,
          message: "Silahkan signin terlebih dahulu",
          error: [{
            field: "accessToken",
            message: "Unauthorized"
          }],
          source: "isPlayerMiddleware",
          redirect: "/membership/signin"
        }
      }
      const jwtPayload = await jwt.verify(accessTokenValue);
      const playerId = jwtPayload.sub.p_player_id;
      const player = await getPlayerById(playerId);
      if (player === null || player === undefined) {
        set.status = 401;
        return {
          success: false
        }
      }
      return {
        success: true,
        player
      };
    })
}

export { isPlayerMiddleware }

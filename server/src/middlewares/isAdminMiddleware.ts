import { Elysia } from "elysia";
import { jwt } from "@elysiajs/jwt";
import { getAdminById } from "@/models/playerModel";
import { JWT_NAME } from "@/config/constant-jwt";

const app = new Elysia();
const isAdminMiddleware = () => {
  return app
    .use(
      jwt({
        name: JWT_NAME,
        secret: Bun.env.JWT_SECRET!,
      })
    )
    .derive(async ({jwt, set, headers, request}) => {
      const bearer = headers.authorization?.split(' ')[1];
      // hanle if accesToken is not exist
      if (request.url.includes('/swagger')) {
        return; 
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

      const playerId = Number(jwtPayload.sub);
      if (isNaN(playerId)) {
        set.status = 401;
        return {
          authorized: false
        }
      }
      const admin = await getAdminById(playerId);
      if (admin === null || admin === undefined) {
        set.status = 401;
        return {
          isAdmin: false
        }
      }
      if (!admin) {
        set.status = 401;
        return {
          isAdmin: false
        }
      }
      return {
        isAdmin: true,
        admin
      };
    }) 
}

export { isAdminMiddleware }

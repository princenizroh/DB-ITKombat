import { Elysia } from "elysia";
import { jwt } from "@elysiajs/jwt";
import { getAdminById } from "@/models/playerModel";
import { JWT_NAME } from "@/config/jwt";

const isAdminMiddleware = (app: Elysia) => {
  return app
    .use(
      jwt({
        name: JWT_NAME,
        secret: Bun.env.JWT_SECRET!,
      })
    )
    .derive(async ({jwt, set, cookie }:{ jwt: any, set: any, cookie: any }) => {
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
          source: "isAdminMiddleware",
          redirect: "/membership/signin"
        }
      }
      const jwtPayload = await jwt.verify(accessTokenValue);
      console.log("Payload:", jwtPayload);
      const playerId = Number(jwtPayload.sub.p_player_id);
      const role = jwtPayload.sub.p_role;
      console.log("Role:", role);
      const [admin]= await getAdminById(playerId, role);
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

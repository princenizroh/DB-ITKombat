import { Elysia } from 'elysia';
import { dbFunction } from '@/config/db';
import { appRouter, authRouter } from '@/routes/api';
import { mypageRouter } from '@/routes/api/mypage';
import { isPlayerMiddleware } from '@/middlewares/isPlayerMiddleware';
import { isAdminMiddleware } from '@/middlewares/isAdminMiddleware';
import { storeRouter, purchaseStoreRouter } from '@/routes/api/store';
import { inventoryRouter } from '@/routes/api/inventory';
const router = new Elysia()
  .use(storeRouter)
  .group('', (group) => {
  group
    .use(isPlayerMiddleware)
    .onError(({ error, set }) => {
      console.error(error);
      set.status = 404;
      return {
        success: false,
        message: 'Internal Server Error',
        error: error.message,
      }
    })
    .onBeforeHandle(({ success, set }) =>  {
      if (!success) {
        set.status = 401
        return {
          message: "Silahkan signin terlebih dahulu",
          error: [{
            field: "accessToken",
            message: "Unauthorized"
          }],
          redirect: "/membership/signin"
        }
      }
    })
    .use(appRouter)
    .use(purchaseStoreRouter)
    .use(mypageRouter)
    .use(inventoryRouter)
    .guard(app => app
      .use(isAdminMiddleware)
      .onBeforeHandle(({ isAdmin }) => {
        if (!isAdmin) {
          return {
            success: false,
            message: "Silahkan signin terlebih dahulu",
            error: [{
              field: "accessToken",
              message: "Unauthorized"
            }],
            redirect: "/membership/signin"
          }
        }
      }) 
      .get("/activity", async ({ jwt, set ,cookie: { accessToken }, query} : { jwt: any, set: any, cookie: any, query: any}) => {
        try {
          const accessTokenValue = accessToken.value;
          if (!accessTokenValue) {
            set.status = 401;
            return {
              success: false,
              message: "Silahkan signin terlebih dahulu",
              error: [{
                field: "accessToken",
                message: "Unauthorized"
              }],
              redirect: "/membership/signin"
            }
          }
          const jwtPayload = await jwt.verify(accessTokenValue);
          const role = 'admin';
          const isAdmin = jwtPayload.sub.p_role;
          if (isAdmin !== role) {
            set.status = 401;
            return {
              success: false,
              message: "Anda bukan admin",
              error: [{
                field: "accessToken",
                message: "Unauthorized"
              }],
            }
          }

          const colums = ['player_id', 'username', 'type_activity', 'time_activity'];
          const result = await dbFunction("get_player_activity", colums);
          return {
            success: true,
            message: 'get activity success',
            data: result,
          };
        } catch (error) {
          console.error(error);
          return {
            message: "Failed to fetch activity",
            error: (error as Error).message
          };
        }
      })
    )
    return group;
  })
  .group('', (group) => {
  group
    .use(authRouter)
    return group;
  })


export { router};

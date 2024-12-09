import { Elysia } from 'elysia';
import { topupRouter, authRouter } from '@/routes/api';
import { mypageRouter } from '@/routes/api/mypage';
import { isPlayerMiddleware } from '@/middlewares/isPlayerMiddleware';
import { isAdminMiddleware } from '@/middlewares/isAdminMiddleware';
import { storeRouter, purchaseStoreRouter, adminStoreRouter } from '@/routes/api/store';
import { activityRouter } from '@/routes/api/activity';
import { battleRouter } from '@/routes/api/battle'
import { inventoryRouter } from '@/routes/api/inventory';
const router = new Elysia()
  .group('', (group) => {
  group
    .use(authRouter)
    .use(storeRouter)
    return group;
  })
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
    .use(topupRouter)
    .use(battleRouter)
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
      .use(activityRouter)
      .use(adminStoreRouter)
    )
    return group;
  })


export { router};

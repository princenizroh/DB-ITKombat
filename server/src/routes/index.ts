import { Elysia } from 'elysia';
import { authRouter } from '@/routes/api';
import { mypageRouter } from '@/routes/api/mypage';
import { isPlayerMiddleware } from '@/middlewares/isPlayerMiddleware';

const router = new Elysia()
  .use(isPlayerMiddleware)
  .use(authRouter)
  .use(mypageRouter);

export { router };

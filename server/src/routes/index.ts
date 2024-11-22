import { Elysia } from 'elysia';
import { authRouter } from './api/index';

const router = new Elysia()
  .use(authRouter)

export { router as apiRouter };

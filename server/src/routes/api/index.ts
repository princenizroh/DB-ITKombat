import { Elysia } from 'elysia';
import { loginRouter } from './auth/loginRouter';
import { logoutRouter } from './auth/logoutRouter';
import { registerRouter } from './auth/registerRouter';

export const apiRouter = new Elysia()
  .use(loginRouter)
  // .use(registerRouter)
  // .use(logoutRouter);



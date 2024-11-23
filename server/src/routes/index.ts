import { Elysia } from 'elysia';
import { apiRouter } from '@/routes/api';

const router = new Elysia()
  .use(apiRouter)

export { router };

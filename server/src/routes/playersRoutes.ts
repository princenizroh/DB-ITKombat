import { Elysia, t } from 'elysia';
import { getPlayerByIdController } from '@/controllers/getPlayerByIdController';
import { isPlayerMiddleware } from '@/middlewares/isPlayerMiddleware';

export const playersRoutes = new Elysia()
  .group('/players', app => {
    return app
      // .use(isPlayerMiddleware)
      .get('/:id', getPlayerByIdController ,{
        params: t.Object({
          id: t.String({
            required: true,
            description: 'Player ID',
          }),
        }),
        detail: {
          summary: 'Get player by ID',
          tags: ['Players'],
        },
      });
  });

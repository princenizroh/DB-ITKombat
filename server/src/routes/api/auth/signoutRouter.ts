import { Elysia } from 'elysia';
import { signoutController } from '@/controllers/auth/signoutController'
import { signoutSummary } from '@/docs/auth/signoutSummary'

const signoutRouter = new Elysia()
  .post(
      '/signout', 
      signoutController,
      {
        ...signoutSummary
      }
    )

export { signoutRouter };

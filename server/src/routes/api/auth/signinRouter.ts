import { Elysia } from 'elysia';
import { signinController } from '@/controllers/auth/signinController'
import { playerSigninSchema } from '@/models/playerModel'
import { signinSummary } from '@/docs/auth/signinSummary'

const signinRouter = new Elysia()
  .post(
      '/signin', 
      signinController,
      {
        body: playerSigninSchema,
        ...signinSummary
      }
    );

export { signinRouter };

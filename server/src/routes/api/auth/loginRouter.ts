import { Elysia } from 'elysia';
import { loginController } from '@/controllers/auth/loginController'
import { playerLogin } from '@/models/playerModel'
import { loginSummary } from '@/docs/loginSummary'

const loginRouter = new Elysia()
  .post(
      '/login', 
      loginController,
      {
        body: playerLogin,
        ...loginSummary
      }
    );

export { loginRouter };

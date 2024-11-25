import { Elysia } from 'elysia';
import { signupController } from '@/controllers/auth/signupController'
import { playerSignupSchema } from '@/models/playerModel'
import { signupSummary } from '@/docs/auth/signupSummary'

const signupRouter = new Elysia()
  .post(
      '/signup', 
      signupController,
    {
      body: playerSignupSchema,
      ...signupSummary
    }
  );
  
export { signupRouter };

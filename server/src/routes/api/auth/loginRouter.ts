import { Elysia } from 'elysia';
import { loginController } from '@/controllers/auth/loginController'

const app = new Elysia({ prefix: '/'});
const loginRouter = () => {
  // app
  // .post('/login', loginController);
}
export { loginRouter };

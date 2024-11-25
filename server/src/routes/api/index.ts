import { Elysia } from 'elysia';
import { signinRouter } from './auth/signinRouter';
import { signoutRouter } from './auth/signoutRouter';
import { signupRouter } from './auth/signupRouter';

const authRouter = new Elysia();
authRouter.group('/membership', (group) => {
  group.use(signinRouter);
  group.use(signupRouter);
  group.use(signoutRouter);
  return group;
});

export { authRouter }

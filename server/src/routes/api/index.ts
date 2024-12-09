import { Elysia } from 'elysia';
import { signinRouter } from './auth/signinRouter';
import { signoutRouter } from './auth/signoutRouter';
import { signupRouter } from './auth/signupRouter';
import { topupUktRouter } from './topup/topupUktRouter';
import { topupDanusRouter } from './topup/topupDanusRouter';
import { topupHistoryRouter } from './topup/topupHistoryRouter';
import { getPackagesRouter } from './topup/getPackagesRouter';
import { transactionRouter } from './topup/transaction/'

const topupRouter = new Elysia()
  .group('/topup', (group) => {
  group
    .use(topupUktRouter)
    .use(topupDanusRouter)
    .use(topupHistoryRouter)
    .use(getPackagesRouter)
    .use(transactionRouter)
  return group;
});

const authRouter = new Elysia()
  .group('/membership', (group) => {
  group
    .use(signinRouter)
    .use(signupRouter)
    .use(signoutRouter)
  return group;
});

export { topupRouter, authRouter };

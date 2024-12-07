import { Elysia } from 'elysia';
import { transactionHistoryRouter } from './history/transactionHistoryRouter';

const transactionRouter = new Elysia();
transactionRouter.group('/transaction', (group) => {
  group.use(transactionHistoryRouter);
  return group;
});

export { transactionRouter };

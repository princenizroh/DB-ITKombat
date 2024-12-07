import { Elysia } from 'elysia';
import { transactionHistoryController } from '@/controllers/topup/transaction/history/transactionHistoryController';
import { transactionHistorySummary } from '@/docs/topup/transactionHistorySummary';

const transactionHistoryRouter = new Elysia()
  .get(
      '/history',
      transactionHistoryController,
      {
        ...transactionHistorySummary
      }
  )

export { transactionHistoryRouter };

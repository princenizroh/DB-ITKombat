import { Elysia } from 'elysia';
import { topupHistoryController } from '@/controllers/topup/topupHistoryController';
import { topupHistorySummary } from '@/docs/topup/topupHistorySummary';

const topupHistoryRouter = new Elysia()
  .get(
      '/history', 
      topupHistoryController,
      {
        ...topupHistorySummary
      }
    );


export { topupHistoryRouter };



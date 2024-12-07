import { Elysia } from 'elysia';
import { topupUktController } from '@/controllers/topup/topupUktController';
import { topupUktSchema } from '@/models/topupModel';
import { topupUktSummary } from '@/docs/topup/topupUktSummary';

const topupUktRouter = new Elysia()
  .post(
      '/ukt', 
      topupUktController,
      {
        body: topupUktSchema,
        ...topupUktSummary
      }
    );

export { topupUktRouter };



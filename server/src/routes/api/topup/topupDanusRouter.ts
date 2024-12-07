
import { Elysia } from 'elysia';
import { topupDanusController } from '@/controllers/topup/topupDanusController';
import { topupDanusSchema } from '@/models/topupModel';
import { topupDanusSummary } from '@/docs/topup/topupDanusSummary';

const topupDanusRouter = new Elysia()
  .post(
      '/danus', 
      topupDanusController,
      {
        body: topupDanusSchema,
        ...topupDanusSummary
      }
    );

export { topupDanusRouter };



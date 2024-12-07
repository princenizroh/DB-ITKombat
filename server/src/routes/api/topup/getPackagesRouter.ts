import { Elysia } from 'elysia';
import { getPackagesController } from '@/controllers/topup/getPackagesController';
import { getPackagesSummary } from '@/docs/topup/getPackagesSummary';
import { packagesQuerySchema } from '@/models/packagesModel';

const getPackagesRouter = new Elysia()
  .get(
      '/packages', 
      getPackagesController,
      {
        query: packagesQuerySchema,
        ...getPackagesSummary
      }
    );

export { getPackagesRouter };



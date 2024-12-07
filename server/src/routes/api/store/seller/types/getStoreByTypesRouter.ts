import { Elysia } from 'elysia';
import { getStoreByTypesController } from '@/controllers/store/getStoreController';
import { storeQuerySchema } from '@/models/storeModel';
import { getStoreByTypesSummary } from '@/docs/store/getStoreByTypesSummary';
const getStoreByTypesRouter = new Elysia()
  .get(
      '/types', 
      getStoreByTypesController,
      { 
        query: storeQuerySchema,
        ...getStoreByTypesSummary
      }
  )

export { getStoreByTypesRouter };

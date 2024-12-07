import { Elysia } from 'elysia';
import { getInventoryDetailsController } from '@/controllers/inventory/getInventoryController';
import { getInventoryDetailsSummary } from '@/docs/inventory/getInventoryDetailsSummary';
import { inventoryDetailsQuerySchema } from '@/models/inventoryModel';

const getInventoryDetailsRouter = new Elysia()
  .get(
      '/view', 
      getInventoryDetailsController,
      {
        query: inventoryDetailsQuerySchema,
        ...getInventoryDetailsSummary

      }
    )
export { getInventoryDetailsRouter };

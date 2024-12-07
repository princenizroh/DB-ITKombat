import { Elysia } from 'elysia';
import { getPlayerInventoryController } from '@/controllers/inventory/getInventoryController';
import { getPlayerInventorySummary } from '@/docs/inventory/getPlayerInventorySummary';
import { getInventoryDetailsRouter } from './view/getInventoryDetailsRouter';

const getPlayerInventoryRouter = new Elysia()
  .get(
      '/player', 
      getPlayerInventoryController,
      {
        ...getPlayerInventorySummary
      }
    )
  .group (
    '/player', group => {
        group.use(getInventoryDetailsRouter)
        return group
    }
  );
export { getPlayerInventoryRouter };

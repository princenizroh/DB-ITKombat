import { Elysia } from 'elysia';
import { getStoreSalesByIdRouter } from './view/getStoreSalesByIdRouter';
import { buyStoreSalesByIdRouter} from './view/buyStoreSalesByIdRouter';
import { getStoreByTypesRouter } from './getStoreByTypesRouter';

const storeTypesRouter = new Elysia()
  .group('/types', (group) => {
  group
    .use(getStoreSalesByIdRouter)
    .use(getStoreByTypesRouter)
  return group;
});

const purchaseTypesStoreRouter = new Elysia() 
  .group('/types', (group) => {
    group
      .use(buyStoreSalesByIdRouter)
    return group;
  });

export { storeTypesRouter, purchaseTypesStoreRouter }

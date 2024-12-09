import { Elysia } from 'elysia';
import { getStoreSalesByIdRouter } from './view/getStoreSalesByIdRouter';
import { buyStoreSalesByIdRouter} from './view/buyStoreSalesByIdRouter';
import { adminStoreItemRouter } from './admin/adminStoreItemRouter';
import { getStoreByTypesRouter } from './getStoreByTypesRouter';

const storeTypesRouter = new Elysia()
  .group('/types', (group) => {
  group
    .use(getStoreSalesByIdRouter)
    .use(getStoreByTypesRouter)
  return group;
});

const purchaseStoreTypesRouter = new Elysia() 
  .group('/types', (group) => {
    group
      .use(buyStoreSalesByIdRouter)
    return group;
  });

const adminStoreTypesRouter = new Elysia()
  .group('/types', (group) => {
  group
    .use(adminStoreItemRouter) 
  return group;
})

export { storeTypesRouter, purchaseStoreTypesRouter, adminStoreTypesRouter }

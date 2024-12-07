import { Elysia } from 'elysia';
import { getStoreSellerRouter } from './getStoreSellerRouter'
import { storeTypesRouter, purchaseTypesStoreRouter } from './types';

const storeSellerRouter = new Elysia()
  .group('/seller', (group) => {
  group
    .use(getStoreSellerRouter)
    .use(storeTypesRouter)
  return group;
});

const purchaseStoreSellerRouter = new Elysia() 
  .group('/seller', (group) => {
    group
      .use(purchaseTypesStoreRouter)
    return group;
  });

export { storeSellerRouter, purchaseStoreSellerRouter }

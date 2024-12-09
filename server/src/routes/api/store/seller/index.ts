import { Elysia } from 'elysia';
import { getStoreSellerRouter } from './getStoreSellerRouter'
import { storeTypesRouter, purchaseStoreTypesRouter, adminStoreTypesRouter  } from './types';

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
      .use(purchaseStoreTypesRouter)
    return group;
  });

const adminStoreSellerRouter = new Elysia()
  .group('/seller', (group) => {
  group
    .use(adminStoreTypesRouter) 
  return group;
})

export { storeSellerRouter, purchaseStoreSellerRouter, adminStoreSellerRouter }

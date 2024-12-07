import { Elysia } from 'elysia';
import { storeSellerRouter, purchaseStoreSellerRouter } from './seller';

const storeRouter = new Elysia()
  .group('/store', (group) => {
  group
    .use(storeSellerRouter);
  return group;
})

const purchaseStoreRouter = new Elysia()
  .group('/store', (group) => {
  group
    .use(purchaseStoreSellerRouter);
  return group;
})

export { storeRouter, purchaseStoreRouter }

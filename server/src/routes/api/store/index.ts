import { Elysia } from 'elysia';
import { storeSellerRouter, purchaseStoreSellerRouter, adminStoreSellerRouter } from './seller';

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

const adminStoreRouter = new Elysia()
  .group('/store', (group) => {
  group
    .use(adminStoreSellerRouter);
  return group;
})


export { storeRouter, purchaseStoreRouter, adminStoreRouter }

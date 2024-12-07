import { Elysia } from 'elysia';
import { getStoreSellerController } from '@/controllers/store/getStoreController';
import { getStoreSellerSummary } from '@/docs/store/getStoreSellerSummary'

const getStoreSellerRouter = new Elysia()
  .get(
      '/seller',
      getStoreSellerController,
      {
          ...getStoreSellerSummary
      }
  )
export { getStoreSellerRouter }

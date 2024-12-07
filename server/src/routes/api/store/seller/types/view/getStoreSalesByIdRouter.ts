import { Elysia } from 'elysia'
import { getStoreSalesByIdController } from '@/controllers/store/getStoreController'
import { storeSalesQuerySchema, storeSchema } from '@/models/storeModel'
import { getStoreSalesByIdSummary } from '@/docs/store/getStoreSalesByIdSummary'

const getStoreSalesByIdRouter = new Elysia()
  .get(
      '/view',
      getStoreSalesByIdController,
      {
        query: storeSalesQuerySchema,
        ...getStoreSalesByIdSummary
      }
  )

export { getStoreSalesByIdRouter }

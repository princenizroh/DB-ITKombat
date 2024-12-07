
import { Elysia } from 'elysia'
import { storeController } from '@/controllers/store/storeController'
import { storeSchema } from '@/models/storeModel'
import { storeSummary } from '@/docs/store/storeSummary'

const buyStoreSalesByIdRouter = new Elysia()
  .post(
      '/view',
      storeController,
      {
        body: storeSchema,
        ...storeSummary
      }
  )

export { buyStoreSalesByIdRouter }

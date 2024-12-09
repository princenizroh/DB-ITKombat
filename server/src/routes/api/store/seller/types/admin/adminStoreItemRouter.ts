import { Elysia } from 'elysia'
import { adminStoreController } from '@/controllers/store/adminStoreController'

const adminStoreItemRouter = new Elysia()
  .post(
      '/upload',
      adminStoreController
  )

export { adminStoreItemRouter }

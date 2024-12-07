import { Elysia } from 'elysia'
import { adminStoreController } from '@/controllers/store/adminStoreController'

const uploadStoreItemRouter = new Elysia()
  .post(
      '/upload',
      adminStoreController

  )

export { uploadStoreItemRouter }

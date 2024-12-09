import { Elysia } from 'elysia'
import { adminPlayerActivityController } from '@/controllers/activity/adminPlayerActivityController'

const adminPlayerActivityRouter = new Elysia()
  .get(
      '/view',
      adminPlayerActivityController
  )

export { adminPlayerActivityRouter }

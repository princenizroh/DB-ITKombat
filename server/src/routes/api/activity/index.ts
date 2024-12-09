import { Elysia } from 'elysia';
import { adminPlayerActivityRouter } from './admin/adminPlayerActivityRouter'

const activityRouter = new Elysia()
  .group('/activity', (group) => {
  group
    .use(adminPlayerActivityRouter)
  return group;
})

export { activityRouter }

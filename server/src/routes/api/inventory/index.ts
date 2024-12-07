import { Elysia } from 'elysia'
import { getPlayerInventoryRouter } from './player/getPlayerInventoryRouter'

const inventoryRouter = new Elysia()
  .group('/inventory', (group) => {
  group.use(getPlayerInventoryRouter);
  return group;
})

export { inventoryRouter } 

import { Elysia } from 'elysia'
import { battlePlayerRouter } from './battlePlayerRouter'
import { battlePlayerHistoryRouter } from './history/battlePlayerHistoryRouter'
const battlePlayersRouter = new Elysia()
  .group('', (group) => {
  group
    .use(battlePlayerRouter)
    .use(battlePlayerHistoryRouter)
  return group;
})

export { battlePlayersRouter }

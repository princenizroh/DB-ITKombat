import { Elysia } from 'elysia'
import { battlePlayersRouter } from './player'
const battleRouter = new Elysia()
  .group('/battle', (group) => {
  group
    .use(battlePlayersRouter)
  return group;
})

export { battleRouter }

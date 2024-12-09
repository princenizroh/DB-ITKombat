import { Elysia } from 'elysia';
import { battlePlayerController } from '@/controllers/battle/battlePlayerController'

const battlePlayerRouter = new Elysia()
  .post(
      '/player',
      battlePlayerController
  )

export { battlePlayerRouter }

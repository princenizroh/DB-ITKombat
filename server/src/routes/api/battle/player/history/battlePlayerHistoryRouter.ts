import { Elysia } from 'elysia';
import { battlePlayerHistoryController, getMatchDetailsController, getPlayerProfileController, getLeaderboardsRankController,getMatchHistoryPlayerController } from '@/controllers/battle/battlePlayerController'

const battlePlayerHistoryRouter = new Elysia()
  .post(
      '/history',
      battlePlayerHistoryController
  )
  .get(
      '/player/profile', 
      getPlayerProfileController
  )
  .get(
      '/player/history', 
      getMatchHistoryPlayerController
  )
  .get(
      '/match/details', 
      getMatchDetailsController
  )
  .get(
      '/leaderboards', 
      getLeaderboardsRankController
  );

export { battlePlayerHistoryRouter }

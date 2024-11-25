import { Elysia } from 'elysia';
import { mypageInfoController } from '@/controllers/mypage/info/mypageInfoController'
import { mypageInfoViewRouter } from './view/mypageInfoViewRouter';
import { mypageInfoSummary } from '@/docs/mypage/mypageInfoSummary'
import { mypageInfoSchema } from '@/models/mypageModel'
const mypageInfoRouter = new Elysia()
  .post(
      '/info', 
      mypageInfoController,
      {
        body: mypageInfoSchema,
        ...mypageInfoSummary
      }
    )
  .group('/info', group => {
      group.use(mypageInfoViewRouter);
      return group;
  });

export { mypageInfoRouter };


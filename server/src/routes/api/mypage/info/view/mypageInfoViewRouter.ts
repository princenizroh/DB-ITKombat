import { Elysia } from 'elysia';
import { mypageInfoViewController } from '@/controllers/mypage/info/view/mypageInfoViewController'
import { mypageInfoViewSummary } from '@/docs/mypage/mypageInfoViewSummary'

const mypageInfoViewRouter = new Elysia()
  .get(
      '/view', 
      mypageInfoViewController,
      {
          ...mypageInfoViewSummary
      }
    );

export { mypageInfoViewRouter };

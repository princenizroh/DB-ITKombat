import { Elysia } from 'elysia';
import { mypageInfoRouter } from './info/mypageInfoRouter';
const mypageRouter = new Elysia();
mypageRouter.group('/mypage', (group) => {
  group.use(mypageInfoRouter);
 
  return group;
});

export { mypageRouter }

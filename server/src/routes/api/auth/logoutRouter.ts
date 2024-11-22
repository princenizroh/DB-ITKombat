import { Elysia } from 'elysia';

const logoutRouter = new Elysia()
  .post('/logout', (req: any, res: any) => {
    // Implementasi logout
  });

export { logoutRouter };

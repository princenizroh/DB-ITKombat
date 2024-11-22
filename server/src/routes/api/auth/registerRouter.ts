import { Elysia } from 'elysia';

const registerRouter = new Elysia()
  .post('/register', (req: any, res: any) => {
    // Implementasi register
  });

export { registerRouter };

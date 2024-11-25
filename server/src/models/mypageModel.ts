import { t } from 'elysia';

export const mypageInfoSchema = t.Object({
  password: t.String({
    required: true,
    example: 'admin123',
  })
})

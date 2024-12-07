import { t } from 'elysia';

export const packagesQuerySchema = t.Object({
  type: t.String({
    required: true,
    example: 'ukt',
    values: ['ukt', 'danus']
  }),
});

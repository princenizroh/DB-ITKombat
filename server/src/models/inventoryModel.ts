import { t } from 'elysia';

export const inventoryDetailsQuerySchema = t.Object({
  entity_name: t.String({
    required: true,
    example: 'Ochabot'
  }),
})

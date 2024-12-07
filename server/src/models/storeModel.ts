import { t } from 'elysia';

export const storeQuerySchema = t.Object({
  type: t.String({
    required: true,
    example: 'Gear seller',
    values: ['Gear seller', 'Item seller', 'Character seller']
  })
})

export const storeSalesQuerySchema = t.Object({
  store_id: t.String({
    required: true,
    example: 1,
  }),
  seller_type: t.String({
    required: true,
    example: 'Gear seller',
    values: ['Gear seller', 'Item seller', 'Character seller']
  })
})

export const storeSchema = t.Object({
  store_id: t.Integer({
    required: true,
    example: 1
  })
})

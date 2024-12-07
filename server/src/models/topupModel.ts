import { t } from 'elysia';

export const topupDanusSchema = t.Object({
  packageId: t.Integer({
    required: true,
    example: 2,
  })
})

export const topupUktSchema = t.Object({
  packageId: t.Integer({
    required: true,
    example: 2,
  }),
  paymentMethod: t.String({
    required: true,
    example: 'Dana',
    values: ['Dana', 'Gopay']
  })
})

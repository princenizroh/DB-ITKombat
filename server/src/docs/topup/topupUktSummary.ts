import { t } from "elysia";
export const topupUktSummary = {
    detail: {
        summary: "topup Ukt",
        description: "Top up Ukt",
        tags: ["Topup"],
     
        responses: {
            200: {
                description: "Success", 
                schema: t.Object({
                    success: t.Boolean({
                        description: "Indicates if the request was successful.",
                        example: true
                    }),
                    message: t.String({
                        description: "Message indicating the result of the request.",
                        example: "Topup saldo ukt berhasil"
                    }),
                    data: t.Object({ 
                        Id: t.String({
                            description: "playerId",
                            example: "1"
                        }),
                        packageId: t.String({
                            description: "packageId",
                            example: "1"
                        }),
                        paymentMethod: t.String({
                            description: "paymentMethod",
                            example: "dana"
                        }),
                        paymentAmount: t.String({
                            description: "paymentAmount",
                            example: "6000"
                        }),
                    }),
                    description: t.String({
                        description: "description",
                        example: "Rp.6.000 / 20 UKT"
                    })
                })
            },
            400: {
                description: "Bad Request",
                schema: t.Object({
                    success: t.Boolean({
                        description: "Indicates if the request was successful.",
                        example: false
                    }),
                    message: t.String({
                        description: "Message indicating the result of the request.",
                        example: "Paket atau metode pembayaran tidak boleh kosong"
                    }),
                    errors: t.Array(t.Object({
                        field: t.String({
                            description: "Field name.",
                            example: "packageId or paymentMethod is required"
                        }),
                        message: t.String({
                            description: "Error message.",
                            example: "Invalid request."
                        }),
                    }))
                })
            },
            401: {
                description: "Unauthorized",
                schema: t.Object({
                    success: t.Boolean({
                        description: "Indicates if the request was successful.",
                        example: false
                    }),
                    message: t.String({
                        description: "Message indicating the result of the request.",
                        example: "Silahkan signin terlebih dahulu."
                    }),
                    errors: t.Array(t.Object({
                        field: t.String({
                            description: "Field access token.",
                            example: "accesToken"
                        }),
                        message: t.String({
                            description: "Error message.",
                            example: "Unauthorized."
                        }),
                    }), {
                        description: "Array of errors."
                    })
                })
            },
        }
    }
};

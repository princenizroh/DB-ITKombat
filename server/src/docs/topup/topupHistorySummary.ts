import { t } from "elysia";
export const topupHistorySummary = {
    detail: {
        summary: "topup player history",
        description: "topup player history.",
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
                        example: "Mendapatkan riwayat topup berhasil."
                    }),
                    data: t.Object({
                        log_id : t.String({ 
                            description: "log_id",
                            example: "1"
                        }),
                        payment_method : t.String({
                            description: "payment_method",
                            example: "Dana"
                        }),
                        ukt_purchased : t.String({
                            description: "ukt_purchased",
                            example: "20"
                        }),
                        amount_paid : t.String({
                            description: "amount_paid",
                            example: "6000"
                        }),
                        purchase_date : t.String({
                            description: "purchase_date",
                            example: "2024-08-10 10:00:00"
                        })
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
                        example: "Error during get topup history."
                    }),
                    error: t.String({
                        description: "Error message.",
                        example: "Invalid Request."
                    }),
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
                    }))
                })
            },
        }
    }
};

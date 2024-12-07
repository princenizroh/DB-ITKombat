
import { t } from "elysia";
export const getPlayerInventorySummary = {
    detail: {
        summary: "get player inventory",
        description: "get player inventory.",
        tags: ["Inventory"],
     
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
                        example: "Mendapatkan riwayat transaksi berhasil."
                    }),
                    data: t.Object({
                        history_id : t.String({ 
                            description: "history_id",
                            example: "1"
                        }),
                        transaction_date : t.String({ 
                            description: "player_id",
                            example: "2024-08-01 00:00:00"
                        }),
                        transaction_before : t.String({ 
                            description: "transaction_before",
                            example: "0"
                        }),
                        transaction_after : t.String({ 
                            description: "transaction_after",
                            example: "60"
                        }),
                        transaction_type : t.String({ 
                            description: "transaction_type",
                            example: "Topup Ukt"
                        }),
                    }),
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
                        example: "Error during get transaction history."
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

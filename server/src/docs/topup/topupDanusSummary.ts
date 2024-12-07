import { t } from "elysia";
export const topupDanusSummary = {
    detail: {
        summary: "topup danus",
        description: "Top up danus",
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
                        example: "Pembelian saldo danus berhasil"
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
                    }),
                    description: t.String({
                        description: "description",
                        example: "5 UKT / 500 Danus" 
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
                        example: "Paket tidak boleh kosong"
                    }),
                    errors: t.Array(t.Object({
                        field: t.String({
                            description: "Field name.",
                            example: "packageId is required"
                        }),
                        message: t.String({
                            description: "Error message.",
                            example: "Invalid request."
                        }),
                    }), {
                        description: "Array of errors."
                    })
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

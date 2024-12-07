import { t } from "elysia";
export const getPackagesSummary = {
    detail: {
        summary: "get package danus and ukt",
        description: "get package danus and ukt",
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
                        example: "Mendapatkan paket danus dan ukt berhasil"
                    }),
                    data: t.Object({ 
                        packagesDanus: t.Array(t.Object({
                            packageId: t.Integer({
                                description: "packageId",
                                example: 1
                            }),
                            danusAmount: t.Integer({
                                description: "danusAmount",
                                example: 500
                            }),
                            required_ukt: t.Integer({
                                description: "required_ukt",
                                example: 5
                            }),
                            description: t.String({
                                description: "description",
                                example: "5 UKT / 500 Danus"
                            })
                        })),
                        packagesUkt: t.Array(t.Object({
                            packageId: t.Integer({
                                description: "packageId",
                                example: 1
                            }),
                            uktAmount: t.Integer({
                                description: "uktAmount",
                                example: 20
                            }),
                            price: t.Integer({
                                description: "price",
                                example: 6000
                            }),
                            description: t.String({
                                description: "description",
                                example: "Rp.6.000 / 20 UKT"
                            })
                        }))
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
                        example: "Error during getting packages."
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
                    }), {
                        description: "Array of errors."
                    })
                })
            },
        }
    }
};

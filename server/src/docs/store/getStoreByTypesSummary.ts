import { t } from "elysia";
export const getStoreByTypesSummary = {
    detail: {
        summary: "get store type",
        description: "get store type",
        tags: ["Store"],
     
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
                        example: "Mendapatkan tipe penjual toko berhasil"
                    }),
                    data: t.Object({ 
                        store_id : t.Integer({
                            description: "Store ID",
                            example: 1
                        }),
                        sales : t.String({
                            description: "Penjualan item",
                            example: "ochabot"
                        }),
                        sales_class : t.String({
                            description: "Tipe kelas penjualan",
                            example: "Weapon"
                        }),
                        price : t.Integer({
                            description: "Harga penjualan",
                            example: 7000
                        }),
                        currency : t.String({
                            description: "Mata uang",
                            example: "danus"
                        }),
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
                        example: "Error during get store by type"
                    }),
                    error: t.String({
                        description: "Error message.",
                        example: "Invalid Request."
                    }),
                })
            },
        }
    }
};

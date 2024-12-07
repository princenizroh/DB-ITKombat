import { t } from "elysia";
export const getStoreSellerSummary = {
    detail: {
        summary: "get store seller",
        description: "get store seller",
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
                        example: "Mendapatkan penjualan toko berhasil"
                    }),
                    data: t.Object({ 
                        seller_id : t.Integer({
                            description: "Seller ID",
                            example: 1
                        }),
                        seller_name : t.String({
                            description: "Seller Name",
                            example: "Jokowi"
                        }),
                        seller_type : t.String({
                            description: "Seller Type",
                            example: "Gear seller"
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
                        example: "Error during get seller."
                    }),
                    error: t.String({
                        description: "Error message.",
                        example: "Invalid Request."
                    }),
                })
            }
        }
    }
};

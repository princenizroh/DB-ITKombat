import { t } from "elysia";
export const mypageInfoViewSummary = {
    detail: {
        summary: "mypage info view",
        description: "mypage info view a player.",
        tags: ["Mypage"],
     
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
                        example: "Menampilkan informasi mypage berhasil."
                    }),
                    data: t.Object({
                        username: t.String({
                            description: "Username player",
                            example: "zaky"
                        }),
                        email: t.String({
                            description: "email player",
                            example: "zaki@gmail.com"
                        }),
                        password: t.String({
                            description: "password player",
                            example: "admin123"
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
                        example: "Error during mypage info view."
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

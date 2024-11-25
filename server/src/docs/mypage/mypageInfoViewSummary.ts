import { t } from "elysia";
export const mypageInfoViewSummary= {
    detail: {
        summary: "mypageInfoSummary",
        description: "mypageInfoSummary a player.",
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
                        example: "Player registered successfully."
                    }),
                    data: t.Object({
                        player_id: t.String({
                            description: "id player",
                            example: "1"
                        }),
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
                    accesToken: t.String({
                        description: "JWT token for the user.",
                        example: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
                    }),
                    timestamp: t.String({
                        description: "timestamp",
                        example: "2022-01-01 00:00:00"
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
                        example: "Invalid request."
                    }),
                    errors: t.Array(t.Object({
                        field: t.String({
                            description: "Field name.",
                            example: "username"
                        }),
                        message: t.String({
                            description: "Error message.",
                            example: "Invalid username."
                        }),
                    }), {
                        description: "Array of errors."
                    })
                }, {
                    required: ["success", "message", "errors"]
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

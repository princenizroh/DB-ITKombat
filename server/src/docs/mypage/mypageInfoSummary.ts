import { t } from "elysia";
export const mypageInfoSummary = {
    detail: {
        summary: "mypageinfo",
        description: "mypageinfo for require password to go mypageinfo view to show the information of the player.",
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
                        example: "Password valid"
                    }),
                    data: t.Object({ 
                        p_password: t.String({
                            description: "password player",
                            example: "admin123"
                        }),
                        p_player_id: t.String({
                            description: "id player",
                            example: "1"
                        }),
                    }),
                    redirect: t.String({
                        description: "redirect to mypageinfo view",
                        example: "/mypage/info/view"
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
                        example: "Invalid password."
                    }),
                    errors: t.Array(t.Object({
                        field: t.String({
                            description: "Field name.",
                            example: "password"
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
            422: {
                description: "Unprocessable Content",
                schema: t.Object({
                    success: t.Boolean({
                        description: "Indicates if the request was successful.",
                        example: false
                    }),
                    message: t.String({
                        description: "Message indicating the result of the request.",
                        example: "Password harus minimial 8 karakter"
                    }),
                    errors: t.Array(t.Object({
                        field: t.String({
                            description: "Field password.",
                            example: "password must be at least 8 characters"
                        }),
                        message: t.String({
                            description: "Error message.",
                            example: "Unprocessable content."
                        }),
                    }), {
                        description: "Array of errors."
                    })
                })
            }

        }
    }
};

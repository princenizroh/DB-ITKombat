
import { t } from "elysia";
export const signoutSummary = {
    detail: {
        summary: "signout",
        description: "signout a player.",
        tags: ["Auth"],

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
                        example: "Player signout successfully."
                    }),
                    data: t.Object({
                        username: t.String({
                            description: "Username player",
                            example: "zaky"
                        }),
                        type_activity: t.String({
                            description: "email",
                            example: "signout"
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
                        example: "Signout gagal. Silahkan signin terlebih dahulu"
                    }),
                    errors: t.Array(t.Object({
                        field: t.String({
                            description: "Field name.",
                            example: "accesToken and refreshToken"
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

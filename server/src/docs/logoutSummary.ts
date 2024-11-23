
import { t } from "elysia";
export const logoutSummary = {
    detail: {
        summary: "Logout",
        description: "Login a nplayer.",
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
                    example: "Player logout successfully."
                }),
                data: t.Object({
                    username: t.String({
                        description: "Username player",
                        example: "zaky"
                    }),
                    type_activity: t.String({
                        description: "email",
                        example: "login"
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
                        example: "Invalid request."
                    }),
                    errors: t.Array(t.Object({
                        field: t.String({
                            description: "Field name.",
                            example: "username"
                        }),
                        message: t.String({
                            description: "Error message.",
                            example: "user tidak ditemukan."
                        }),
                    }), {
                        description: "Array of errors."
                    })
                }, {
                    required: ["success", "message", "errors"]
                })
            }
        }
    }
};

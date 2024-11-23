import { t } from "elysia";
export const registerSummary = {
    detail: {
        summary: "Register",
        description: "Register a new player.",
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
                    example: "Player registered successfully."
                }),
                data: t.Object({
                    username: t.String({
                        description: "Username player",
                        example: "zaky"
                    }),
                    email: t.String({
                        description: "email player",
                        example: "zaky@gmail.com"
                    }),
                    password: t.String({
                        description: "password player",
                        example: "admin123"
                    }),
                    role: t.String({
                        description: "role player",
                        example: "player"
                    }),
                    type_activity: t.String({
                        description: "email",
                        example: "register"
                    }), 
                }),
                token: t.String({
                    description: "JWT token for the user.",
                    example: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
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
                            example: "email and username"
                        }),
                        message: t.String({
                            description: "Error message.",
                            example: "Invalid email and username."
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

import { Elysia, t } from "elysia";
import { db, SetupDatabase, dbFunction} from "@/config/db";
import { cors } from "@elysiajs/cors";
import { swagger } from "@elysiajs/swagger";
import { router} from "@/routes";

const app = new Elysia()

SetupDatabase()
app
  .use(cors())
  .use(router)
  // .use(auth)
  .use(
    swagger({
      documentation: {
        info: {
          title: "Elysia Demo",
          description: "Database ITKombat",
          version: "1.0.0",
        },
        components: {
          securitySchemes: {
            JwtAuth: {
              type: "http",
              scheme: "bearer",
              bearerFormat: "JWT"
            }
          }
        },
        servers: [{ url: "http://localhost:3000" }]
      },
      swaggerOptions: {
        persistAuthorization: true
      }  
    })
  )
  .decorate('db', db)
  .decorate('dbFunction', dbFunction)
  .get("/", ({ set }) =>  {
    set.redirect = "/swagger";
  })

  .get("/check-cookie", ({ cookie, set }) => {
    console.log("Cookies diterima:", cookie); // Log semua cookies

    const accessToken = cookie?.accessToken;
    console.log("Access Token:", accessToken); // Log spesifik untuk accessToken

    if (!accessToken) {
        set.status = 401;
        return {
            success: false,
            message: "Cookie tidak ditemukan. Anda belum login.",
        };
    }

    return {
        success: true,
        message: "Cookie ditemukan.",
    };
  })

  .get("/Hello", () => "Hello Elysia")

  .listen(Bun.env.PORT!);

console.log(
  `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);

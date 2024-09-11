import { Elysia, t } from "elysia";
import { createDb } from "./db";

const app = new Elysia()
  .decorate('db', createDb())
  .get("/", () => "Hello Elysia")
  .get("/users", () => "list users")
  .get("/users/:id", ({db, params}) => {
    const userId = params.id
    console.log(`getting user by id ${userId}`)
    return db.query("SELECT * FROM users WHERE user_id = $user_id")
      .get({
      $user_id: params.id
    })
    return "single user handler"
  },{
    params: t.Object({
      id: t.Numeric()
    })
  }
  )
.post("/users", async ({ body, db }) => {
    try {
      const { first_name, last_name, email, about } = body;  // Parsing body JSON langsung
      console.log(`Creating user: ${first_name} ${last_name}`);

      // Masukkan data ke dalam database
      db.run(
        "INSERT INTO users (first_name, last_name, email, about) VALUES (?, ?, ?, ?)", 
        [first_name, last_name, email, about]
      );

      return {
        message: "User created successfully!",
        user: { first_name, last_name, email, about }
      };
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to create user",
        error: error.message
      };
    }
  })
  .listen(3000);

console.log(
  `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);

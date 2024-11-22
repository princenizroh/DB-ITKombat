import { Elysia, t } from "elysia";
import { db, SetupDatabase, dbFunction} from "@/config/db";
import { cors } from "@elysiajs/cors";
import { playerRoutes } from "@/routes/playerRoutes";
import { isPlayerMiddleware } from "@/middlewares/isPlayerMiddleware";
import { Service } from "@/services/fibo";
import { swagger } from "@elysiajs/swagger";
import { playersRoutes } from "@/routes/playersRoutes"
import { playerLogin, playerRegister, playerLogout } from "@/models/playerModel";
import { registerSummary } from "@/summary/registerSummary";
import { loginSummary } from "@/summary/loginSummary";
import { logoutSummary } from "@/summary/logoutSummary";
import moment from 'moment-timezone';
import jwt from "@elysiajs/jwt";
import { REFRESH_TOKEN_EXP,ACCESS_TOKEN_EXP,JWT_NAME } from "@/config/constant-jwt";
import { getExpTimestamp } from "./utils/getExpTimestamp";

const app = new Elysia()

SetupDatabase()
app
  .use(cors())
  .use(isPlayerMiddleware)
  .use(playersRoutes)
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
  .get("/", ({ set }) =>  {
    set.redirect = "/swagger";
  })
  .post("/login", 
    async ({jwt, body, db, set, cookie: { accesToken } }: {jwt: any, body: { username: string, password: string }, db: any, set: any, cookie: any }) => {
    const { username, password } = body;
    try {
      const [result] = await db('login', [username, password]);
      console.log("Login result:", result);

      if (!result) {
          set.status = 400;
          return {
              success: false,
              message: "Invalid username or password",
              error: "Invalid request"
          };
      }

      const payload = result;
      console.log("Payload:", payload);
      const secret = Bun.env.JWT_SECRET!;
      console.log("Secret:", secret);
      const exp = getExpTimestamp(ACCESS_TOKEN_EXP);
      console.log("Exp:", exp);
      const timestamp = moment().tz('Asia/Kuala_Lumpur').format('YYYY-MM-DD HH:mm:ss');
      const accesJWTToken = await jwt.sign({          
          sub: payload, 
          exp: exp
      })
      console.log("JWT Token:", accesJWTToken);
      accesToken.set ({
          value: accesJWTToken,
          httpOnly: true,
          maxAge: ACCESS_TOKEN_EXP,
          path: '/',
        });
      return {
        success: true,
        message: 'Login successful',
        data: result,
        accesToken: accesJWTToken,
        timestamp
      };
    } catch (error) {
      console.error('Error during login:', error);
      return {
        success: false,
        message: "Login failed",
        error: (error as Error).message
      };
    } 
  },{ 
      body: playerLogin,
      ...loginSummary
    }) 
  .post("/register", async ({ body, jwt, db, set }: { body: { username: string, email: string, password: string}, jwt: any ,db: any, set: any }) => {
    
    const { username, email, password } = body;
    try {
      const [result] = await db('register',
        [username, email, password]
      );
      if (!result) {
          set.status = 400;
          return {
              success: false,
              message: "Invalid username or password",
              error: "Invalid request"
          };
      }
      const payload = result;
      console.log("Payload:", payload);
      const secret = Bun.env.JWT_SECRET!;
      const exp = getExpTimestamp(ACCESS_TOKEN_EXP);
      const timestamp = moment().tz('Asia/Kuala_Lumpur').format('YYYY-MM-DD HH:mm:ss');
      const accesJWTToken = await jwt.sign(payload, secret , {expiresIn: exp});
      return {
        success: true,
        message: "Register successful",
        data: result,
        accesToken: accesJWTToken,
        timestamp
      };
    } catch (error) {
      console.error('Error during register:', error);
      return {
        success: false,
        message: "Register failed",
        error: (error as Error).message,
      };
    } 
  }, { 
      body: playerRegister,
      ...registerSummary
    })
  .post("/logout", async ({ body, db, cookie: { accesToken }, set }: { jwt: any, body:any,  set: any, db: any, cookie: any }) => {
    const { username } = body;
    try {
      accesToken.remove();

      const [result] = await db('logout', [username]); 

      return {
        success: true,
        message: "Logout successful",
        data: result
      }
    } catch (error) {
      console.error('Error during logout:', error);
      return {
        success: false,
        message: "Logout failed",
        error: (error as Error).message,
      };
    }
  }, {
      body: playerLogout,
      ...logoutSummary
    })
  .get("/get/:id", async ({ jwt, set, headers, db}: { params: { id: string }, jwt: any ,headers: any, set: any, db: any }) => { 
    const bearer = headers.authorization?.split(' ')[1];
    const jwtPayload = await jwt.verify(bearer);
    console.log("JWT Payload:", jwtPayload); // Log payload jika token valid

    if (!jwtPayload) {
        set.status = 401;

        return {
            success: false,
            message: "Unauthorized."
        }
    }

    const id = jwtPayload.sub.p_player_id;
    console.log("ID:", id); 

    const user = await db('getPlayerById', [id]);

    return {
        success: true,
        message: "Successfully retrieved user.",
        data: user
    }
  },{
      params: t.Object({
          id: t.String({
              required: true,
              example: '1'
          })
      }),
    })

  .get("/activity", async () => {
    try {
      const result = await dbFunction("get_player_activity");
      return {
        success: true,
        message: 'get activity success',
        data: result,
      };
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch activity",
        error: (error as Error).message
      };
    }
  })
  .get("/Hello", () => "Hello Elysia")
  .get("/fibo/:number", ({ params }: { params: { number: string } }) => {
    const number = Number(params.number);
    return Service.fibo(number);
  }
  , {
    params: t.Object({
      number: t.Numeric()
    })
  })

  .get("/player", async ({ db }: { db: any }) => {
    try {
      const res = await db.query("SELECT * FROM player");
      return res.rows;
      db.end()
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch players",
        error: (error as Error).message
      };
    }
  })
  .get("/player/:id", async ({ db, params }: { db: any, params: { id: string } }) => {
    const playerId = params.id;
    const res = await db.query("SELECT * FROM player WHERE player_id = $1", [playerId]);
    console.log(`getting user by id ${playerId}`);
    return res.rows[0];
  }, {
    params: t.Object({
      id: t.Numeric()
    })
  })
  .get("/login-history", async ({ db }: { db: any }) => {
    try {
      const res = await db.query("SELECT * FROM login_history");
      return res.rows;
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch login history",
        error: (error as Error).message
      };
    }
  })
  .get("/login-history/:id", async ({ db, params }: { db: any, params: { id: string } }) => {
    try {
      const loginHistoryId = params.id;
      const res = await db.query("SELECT * FROM login_history WHERE login_history_id = $1", [loginHistoryId]);
      return res.rows[0];
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch login history",
        error: (error as Error).message
      };
    }
  })
  .get("/balances", async ({ db }: { db: any }) => {
    try {
      const res = await db.query("SELECT * FROM balances");
      return res.rows;
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch balances",
        error: (error as Error).message
      };
    }
  })
  .get("/balances/:id", async ({ db, params }: { db: any, params: { id: string } }) => {
    try {
      const balanceId = params.id;
      const res = await db.query("SELECT * FROM balances WHERE balance_id = $1", [balanceId]);
      return res.rows[0];
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch balance",
        error: (error as Error).message
      };
    }
  })
  .get("/gears", async ({ db }: { db: any }) => {
    try {
      const res = await db.query("SELECT * FROM gears");
      return res.rows;
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch gears",
        error: (error as Error).message
      };
    }
  })
  .get("/gears/:id", async ({ db, params }: { db: any, params: { id: string } }) => {
    try {
      const gearId = params.id;
      const res = await db.query("SELECT * FROM gears WHERE gear_id = $1", [gearId]);
      return res.rows[0];
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch gear",
        error: (error as Error).message
      };
    }
  })
  .get("/profile", async ({ db }: { db: any }) => {
    try {
      const res = await db.query("SELECT * FROM profile");
      return res.rows;
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch profile",
        error: (error as Error).message
      };
    }
  })
  .get("/profile/:id", async ({ db, params }: { db: any, params: { id: string } }) => {
    try {
      const profileId = params.id;
      const res = await db.query("SELECT * FROM profile WHERE profile_id = $1", [profileId]);
      return res.rows[0];
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch profile",
        error: (error as Error).message
      };
    }
  })
  .get("/transactions", async ({ db }: { db: any }) => {
    try {
      const res = await db.query("SELECT * FROM transactions");
      return res.rows;
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch transactions",
        error: (error as Error).message
      };
    }
  })
  .post("/players", async ({ body, db }: { body: any, db: any }) => {
    try {
      const { username, email, password, favourite_animal } = body as { username: string, email: string, password: string, favourite_animal: string };
      console.log(`Creating Player: ${username}`);

      await db.query(
        "INSERT INTO players (username, email, password, favourite_animal) VALUES ($1, $2, $3, $4)",
        [username, email, password, favourite_animal]
      );

      return {
        message: "Player created successfully!",
        player: { username, email, password, favourite_animal }
      };
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to create user",
        error: (error as Error).message
      };
    }
  })
  .post("/login-history", async ({ body, db }: { body: any, db: any }) => {
    try {
      const { login_data, player_id } = body as { login_data: string, player_id: number };
      console.log(`Logging login for player ID: ${player_id}`);

      await db.query(
        "INSERT INTO Login_history (login_data, player_id) VALUES ($1, $2)",
        [login_data, player_id]
      );

      return { message: "Login history added successfully!" };
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to add login history",
        error: (error as Error).message
      };
    }
  })
  .post("/developers", async ({ body, db }: { body: any, db: any }) => {
    try {
      const { login_history_id, anouncement_data } = body as { login_history_id: number, anouncement_data: string };
      console.log(`Adding developer anouncement for login history ID: ${login_history_id}`);

      await db.query(
        "INSERT INTO developers (login_history_id, anouncement_data) VALUES ($1, $2)",
        [login_history_id, anouncement_data]
      );

      return {
        message: "Developers announcement added successfully!"
      };
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to add developer announcement",
        error: (error as Error).message
      };
    }
  })
  .post("/gears", async ({ body, db }: { body: any, db: any }) => {
    try {
      const { gear_name, gear_type, gear_exp, gear_price, gear_grade, gear_description, base_atack, base_defense, base_intelligence, obtained_at, character_id, player_id } = body as { gear_name: string, gear_type: string, gear_exp: number, gear_price: number, gear_grade: string, gear_description: string, base_atack: number, base_defense: number, base_intelligence: number, obtained_at: string, character_id: number, player_id: number };
      console.log(`Adding gear: ${gear_name}`);

      await db.query(
        "INSERT INTO gears (gear_name, gear_type, gear_exp, gear_price, gear_grade, gear_description, base_atack, base_defense, base_intelligence, obtained_at, character_id, player_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)",
        [gear_name, gear_type, gear_exp, gear_price, gear_grade, gear_description, base_atack, base_defense, base_intelligence, obtained_at, character_id, player_id]
      );

      return {
        message: "Gear added successfully!"
      };
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to add gear",
        error: (error as Error).message
      };
    }
  })
  .post("/characters", async ({ body, db }: { body: any, db: any }) => {
    try {
      const { character_name, character_type, character_price, character_grade, base_attack, base_defense, base_intelligence, player_id } = body as { character_name: string, character_type: string, character_price: number, character_grade: string, base_attack: number, base_defense: number, base_intelligence: number, player_id: number };
      console.log(`Adding character: ${character_name}`);

      await db.query(
        "INSERT INTO characters (character_name, character_type, character_price, character_grade, base_attack, base_defense, base_intelligence, player_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)",
        [character_name, character_type, character_price, character_grade, base_attack, base_defense, base_intelligence, player_id]
      );

      return {
        message: "Character added successfully!"
      };
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to add character",
        error: (error as Error).message
      };
    }
  })
  .post("/items", async ({ body, db }: { body: any, db: any }) => {
    try {
      const { item_name, item_category, item_subtype, item_price, is_tradeable, item_description, obtainable_from } = body as { item_name: string, item_category: string, item_subtype: string, item_price: number, is_tradeable: boolean, item_description: string, obtainable_from: string };
      console.log(`Adding item: ${item_name}`);

      await db.query(
        "INSERT INTO items (item_name, item_category, item_subtype, item_price, is_tradeable, item_description, obtainable_from) VALUES ($1, $2, $3, $4, $5, $6, $7)",
        [item_name, item_category, item_subtype, item_price, is_tradeable, item_description, obtainable_from]
      );

      return {
        message: "Item added successfully!"
      };
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to add item",
        error: (error as Error).message
      };
    }
  })
  .post("/player_item", async ({ body, db }: { body: any, db: any }) => {
    try {
      const { quantity, obtained_timestamp, is_equipped, is_used, player_id, item_id } = body as { quantity: number, obtained_timestamp: string, is_equipped: boolean, is_used: boolean, player_id: number, item_id: number };
      console.log(`Adding player item: ${item_id}`);

      await db.query(
        "INSERT INTO player_item (quantity, obtained_timestamp, is_equipped, is_used, player_id, item_id) VALUES ($1, $2, $3, $4, $5, $6)",
        [quantity, obtained_timestamp, is_equipped, is_used, player_id, item_id]
      );

      return {
        message: "Player item added successfully!"
      };
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to add player item",
        error: (error as Error).message
      };
    }
  })
  .listen(Bun.env.PORT!);

console.log(
  `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);

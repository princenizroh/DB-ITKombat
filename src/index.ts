import { Elysia, t } from "elysia";
import { createDb } from "@/db";
import { playerRoutes } from "@/routes/playerRoutes";
import { Service } from "@/services/fibo";


const app = new Elysia()
const db = await createDb()

// app.decorate('store', { db });
// playerRoutes(app);
app
  .decorate('db', db)
  .get("/", () => "Hello Elysia")
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
  .listen(3000);

console.log(
  `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);

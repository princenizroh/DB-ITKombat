import { Elysia, t } from "elysia";
import { createDb } from "./db";


const app = new Elysia()
const db = await createDb()

app
  .decorate('db', db)
  .get("/", () => "Hello Elysia")
  .get("/players", async ({ db }) => {
    try {
      const res = await db.query("SELECT * FROM players");
      return res.rows;
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch players",
        error: error.message
      };
    }
  })
  .get("/players/:id", async ({db, params}) => {
    const playerId = params.id
    const res = await db.query("SELECT * FROM players WHERE player_id = $1", [playerId])
    console.log(`getting user by id ${playerId}`)
    return res.rows[0]
  },{
    params: t.Object({
      id: t.Numeric()
    })
  })
  .get("/login-history", async ({ db }) => {
    try {
      const res = await db.query("SELECT * FROM login_history");
      return res.rows;
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch login history",
        error: error.message
      };
    }
  }) 
  .get("/login-history/:id", async ({db, params}) => {
    try {
      const loginHistoryId = params.id
      const res = await db.query("SELECT * FROM login_history WHERE login_history_id = $1", [loginHistoryId])
      return res.rows[0]
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch login history",
        error: error.message
      };
    }
  })
  .get("/developers", async ({ db }) => {
    try {  
      const res = await db.query("SELECT * FROM developers");
      return res.rows;
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch developers",
        error: error.message
      };
    }
  })
  
  .get("/developers/:id", async ({db, params}) => {
    try {
      const developerId = params.id
      const res = await db.query("SELECT * FROM developers WHERE developer_id = $1", [developerId])
      return res.rows[0]
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch developer",
        error: error.message
      };
    }
  })

  .get("/gears", async ({ db }) => {
    try {
      const res = await db.query("SELECT * FROM gears");
      return res.rows;
    } catch (error) { 
      console.error(error);
      return {
        message: "Failed to fetch gears",
        error: error.message
      };
    }
  })

  .get("/gears/:id", async ({db, params}) => {
    try {
      const gearId = params.id
      const res = await db.query("SELECT * FROM gears WHERE gear_id = $1", [gearId])
      return res.rows[0]
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch gear",
        error: error.message
      };
    }
  })

  .get("/characters", async ({ db }) => {
    try {
      const res = await db.query("SELECT * FROM characters");
      return res.rows;
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch characters",
        error: error.message
      };
    }
  })

  .get("/characters/:id", async ({db, params}) => {
    try {
      const characterId = params.id
      const res = await db.query("SELECT * FROM characters WHERE character_id = $1", [characterId])
      return res.rows[0]
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch character",
        error: error.message
      };
    }
  })

  .get("/items", async ({ db }) => {
    try {
      const res = await db.query("SELECT * FROM items");
      return res.rows;
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch items",
        error: error.message
      };
    }
  })

  .get("/items/:id", async ({db, params}) => {
    try {
      const itemId = params.id
      const res = await db.query("SELECT * FROM items WHERE item_id = $1", [itemId])
      return res.rows[0]
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch item",
        error: error.message
      };
    }
  })

  .get("/player_item", async ({ db }) => {
    try {
      const res = await db.query("SELECT * FROM player_item");
      return res.rows;
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to fetch player item",
        error: error.message
      };
    }
  })

  .post("/players", async ({ body, db }) => {
    try {
      const { username, email, password, favourite_animal} = body;  // Parsing body JSON langsung
      console.log(`Creating Player: ${username}`);

      // Masukkan data ke dalam database
      await db.query(
        "INSERT INTO players (username, email, password, favourite_animal) VALUES ($1, $2, $3, $4)", 
        [username, email, password, favourite_animal]
      );

      return {
        message: "Player created successfully!",
        player: { username, email, password, favourite_animal}
      };
    } catch (error) {
      console.error(error);
      return {
        message: "Failed to create user",
        error: error.message
      };
    }
  })

    // Menambahkan login history baru
  .post("/login-history", async ({ body, db }) => {
    try {
      const { login_data, player_id } = body;
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
        error: error.message 
      };
    }
  })

    // Menambahkan pengumuman developer
  .post("/developers", async ({ body, db }) => {
    try {
      const { login_history_id, anouncement_data} = body;
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
        error: error.message 
      };
    }
  })
  
  .post("/gears", async ({ body, db }) => {
    try {
      const { gear_name, gear_type, gear_exp, gear_price, gear_grade, gear_description, base_atack, base_defense, base_intelligence, obtained_at, character_id, player_id } = body;
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
        error: error.message 
      };
    }
  })

  .post("/characters", async ({ body, db }) => {
    try {
      const { character_name, character_type, character_price, character_grade, base_attack, base_defense, base_intelligence, player_id } = body;
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
        error: error.message 
      };
    }
  })

  .post("/items", async ({ body, db }) => {
    try {
      const { item_name, item_category, item_subtype, item_price, is_tradeable, item_description, obtainable_from } = body;
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
        error: error.message
      };
    }
  })

  .post("/player_item", async ({ body, db }) => {
    try {
      const { quantity, obtained_timestamp, is_equipped, is_used, player_id, item_id } = body;
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
        error: error.message
      };
    }
  })


  .listen(3000);

console.log(
  `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);


import { dbFunction } from "@/config/db";

async function getPlayerInventory(player_id: any) {
  const columns = ['inventory_id', 'player_id', 'item_type', 'item_name', 'acquired_date'];
  const result = await dbFunction('get_player_inventory', columns, ['player_id'], [player_id]);
  return result;
}

async function getInventoryDetails(entity_name: any) {
  const columns = ['item_type','entity_name', 'entity_tier', 'entity_type', 'base_attack', 'base_defense', 'base_intelligence', 'item_value'];
  const [result] = await dbFunction('get_inventory_details', columns, ['entity_name'], [entity_name]);
  return result;
}

const getPlayerInventoryController = async ({ jwt, cookie: { accessToken }, set}: { jwt: any, cookie: any, set: any }) => {
  try{
    const accessTokenValue = accessToken.value;
    if(!accessTokenValue) { 
      set.status = 401;
      return {
        success: false,
        message: "Silahkan signin terlebih dahulu",
        error: [{
          field: "accessToken",
          message: "Unauthorized"
        }]
      }
    }
    const jwtPayload = await jwt.verify(accessTokenValue);
    console.log("Payload:", jwtPayload);
    const player_id = jwtPayload.sub.p_player_id;
    const result = await getPlayerInventory(player_id); 
    set.status = 200;
    return {
      success: true,
      message: "Menampilkan isi inventory berhasil",
      data: result
    }

  } catch (error) {
    set.status = 400;
    return {
      success: false,
      message: "Error during get player inventory",
      error: (error as Error).message
    }
  }
}

const getInventoryDetailsController = async ({ jwt, cookie: { accessToken }, set, query }: { jwt: any, cookie: any, set: any, query: any }) => {
  try {
    const accessTokenValue = accessToken.value;
    if (!accessTokenValue) {
      set.status = 401;
      return {
        success: false,
        message: "Silahkan signin terlebih dahulu",
        error: [{
          field: "accessToken",
          message: "Unauthorized"
        }]
      }
    }
    const { entity_name } = query;
    if (!entity_name) {
      set.status = 400;
      return {
        success: false,
        message: "entity_name harus diisi",
        error: [{
          field: "entity_name",
          message: "Invalid request"
        }]
      }
    }
    const jwtPayload = await jwt.verify(accessTokenValue);
    console.log("Payload:", jwtPayload);
    const result = await getInventoryDetails(entity_name);
    set.status = 200;
    return {
      success: true,
      message: "Menampilkan detail item pada inventory berhasil",
      data: result
    }
  } catch (error) {
    set.status = 400;
    return {
      success: false,
      message: "Error during get inventory details",
      error: (error as Error).message
    }
  }
}


export { getPlayerInventoryController, getInventoryDetailsController }

import { dbFunction} from "@/config/db";

async function getStoreSeller() {
  const columns = ['seller_id','seller_name', 'seller_type']
  const seller = await dbFunction('get_seller', columns)
  return seller;
}

async function getStoreByType(seller_type: string){
  const columns = ['store_id', 'sales', 'sales_class', 'price', 'currency' ]
  const seller = await dbFunction('get_store', columns, ['seller_type'], [seller_type])
  return seller;
}

export async function getStoreById(store_id: number){
  const columns = ['store_id', 'sales', 'sales_class', 'price', 'currency']
  const [seller]= await dbFunction('get_store', columns, ['store_id'], [store_id])
  return seller;
}

export async function getBalance(player_id: any) {
  const columns = ['danus', 'ukt'];
  const [balance] = await dbFunction('get_player_balance', columns, ['player_id'], [player_id]);
  return balance;
}

async function getStoreDetails(store_id: number, seller_type: string){
  let columns: string[];
  if (seller_type === 'Gear seller' || seller_type === "Character seller") {
    columns = [
      'entity_name',
      'entity_tier',
      'entity_type',
      'base_attack',
      'base_defense',
      'base_intelligence'
    ];
  } else if (seller_type === 'Item seller') {
    columns = [
      'entity_name',
      'entity_type',
      'item_value',
    ];
  } else {
    throw new Error(`Invalid seller type ${seller_type}`);
  }
  const keys = ['store_id', 'seller_type']
  const values = [store_id, seller_type]
  const details = await dbFunction('get_store_details', columns, keys, values)
  return details;
}

async function getStoreBySales(store_id: number, seller_type: string){
  const columns = ['sales', 'sales_class', 'price', 'currency']
  const keys = ['store_id', 'seller_type']
  const values = [store_id, seller_type]
  const sales = await dbFunction('get_store', columns, keys, values)
  return sales;
}

const getStoreSellerController = async ({ jwt, cookie: { accessToken }, set }: { jwt: any, cookie: any, set: any }) => {
  try {
    let player_id;
    if (accessToken && accessToken.value) {
      const accessTokenValue = accessToken.value;
      const jwtPayload = await jwt.verify(accessTokenValue);
      player_id = jwtPayload.sub.p_player_id;
    }
    const balance = player_id ? await getBalance(player_id) : null;
    const seller = await getStoreSeller();
    set.status = 200;
    return {
      success: true,
      message: "Mendapatkan penjual toko berhasil",
      balance,
      data: seller
    }
  } catch (error) {
    set.status = 400;
    return {
      success: false,
      message: "Error during get seller",
      error: (error as Error).message
    }
  }
}
const getStoreByTypesController = async ({ set, jwt, cookie: { accessToken }, query }: { set: any, jwt: any, cookie: any, query: any }) => {
  try {
    let player_id;
    if (accessToken && accessToken.value) {
      const accessTokenValue = accessToken.value;
      const jwtPayload = await jwt.verify(accessTokenValue);
      player_id = jwtPayload.sub.p_player_id;
    }
    const { type } = query;
    console.log("type", type);
    if (!type || type !== 'Gear seller' && type !== 'Item seller' && type !== 'Character seller') {
      set.status = 400;
      return {
        success: false,
        message: "Tipe penjual harus diisi dengan 'Gear seller', 'Item seller', atau 'Character seller'",
        error: [{
          field: "type",
          message: "Invalid type"
        }]
      }
    }

    const balance = player_id ? await getBalance(player_id) : null;
    const seller = await getStoreByType(type);
    set.status = 200;
    return {
      success: true,
      message: "Mendapatkan tipe penjual toko berhasil",
      balance,
      data: seller
    }
  } catch (error) {
    set.status = 400;
    return {
      success: false,
      message: "Error during get store by type",
      error: (error as Error).message
    }
  }
}

const getStoreSalesByIdController = async ({ set, jwt, cookie: { accessToken }, query }: { set: any, jwt: any, cookie: any, query: any }) => {
  try {
    let player_id;
    if (accessToken && accessToken.value) {
      const accessTokenValue = accessToken.value;
      const jwtPayload = await jwt.verify(accessTokenValue);
      player_id = jwtPayload.sub.p_player_id;
    }
    const { store_id, seller_type } = query;
    if (!store_id || !seller_type) {
      set.status = 400;
      return {
        success: false,
        message: "store_id dan seller_type harus diisi",
        error: [{
          field: "store_id or seller_type",
          message: "Invalid request"
        }]
      }
    }

    const balance = player_id ? await getBalance(player_id) : null;
    const sales = await getStoreBySales(store_id, seller_type);
    const details = await getStoreDetails(store_id, seller_type);
    if (!details || details.length === 0) {
      set.status = 404;
      return {
        success: false,
        message: "Detail item tidak ditemukan untuk store_id dan seller_type ini",
      };
    }
    set.status = 200;
    return {
      success: true,
      message: "Mendapatkan penjualan per 1 item by id toko berhasil",
      balance,
      data: sales,
      details
    }
  } catch (error) {
    set.status = 400;
    return {
      success: false,
      message: "Error during get sales",
      error: (error as Error).message
    }
  }
}

export { getStoreByTypesController, getStoreSellerController, getStoreSalesByIdController};

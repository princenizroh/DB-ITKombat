import { getBalance, getStoreById } from '@/controllers/store/getStoreController'
const storeController = async ({ jwt, db, body, cookie: { accessToken }, set }: { db: any,jwt: any, body: any, cookie: any, set: any }) => {
  try {
   const accessTokenValue = accessToken.value;
    if (!accessTokenValue){
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
    console.log("Access Token:", accessTokenValue);
    const jwtPayload = await jwt.verify(accessTokenValue);
    const id = jwtPayload.sub.p_player_id;
    console.log("Payload:", jwtPayload);
    const { store_id } = body;
    if (!store_id) {
      set.status = 400;
      return {
        success: false,
        message: "Store id harus diisi",
        error: [{
          field: "store_id",
          message: "Invalid request"
        }]
      }
    }
    const [result] = await db('purchase_store', [id, store_id]);
    const balance = await getBalance(id);
    const store = await getStoreById(store_id);

    set.status = 200;
    return {
      success: true,
      message: "Pembelian item berhasil",
      balance,
      data: result,
      store
    }
  } catch (error) {
    set.status = 400;
    return {
      success: false,
      message: "Error during purchase item",
      error: (error as Error).message
    }
  }
}

export { storeController }

import { dbFunction} from "@/config/db";
import { getBalance } from "@/controllers/store/getStoreController";

async function getPurchaseLog(playerId: any) {
  const columns = ['log_id', 'payment_method', 'ukt_purchased', 'amount_paid', 'purchase_date'];
  const packageInfo = await dbFunction('get_purchase_logs', columns, ['player_id'], [playerId]);
  return packageInfo;
}
const topupHistoryController = async ({ set, jwt, cookie: { accessToken }}: { set: any, jwt: any, cookie: any, }) => {
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
        }],
        redirect: "/membership/signin"
      }
    }

    const jwtPayload = await jwt.verify(accessTokenValue);
    const playerId = jwtPayload.sub.p_player_id;
    const result = await getPurchaseLog(playerId);
    const balance = await getBalance(playerId);
    console.log("Result", result);
    set.status = 200;
    return {
      success: true,
      message: "Mendapatkan riwayat topup berhasil",
      balance,
      data: result
    }
  } catch (error) {
    set.status = 400;
    return {
      success: false,
      message: "Error during get topup history",
      error: (error as Error).message
    }
  }
}

export { topupHistoryController };

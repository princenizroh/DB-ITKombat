import { db } from "@/config/db";
import { getPackageDanusInfoAmount, getPackageDanusInfoDesc } from "./getPackagesController";
import { getBalance } from "@/controllers/store/getStoreController";

async function purchaseDanus({ playerId, packageId}: { playerId: number, packageId: any}) {
  const packageInfo = await getPackageDanusInfoAmount(packageId);  
  console.log("Package Info", packageInfo);

  if (packageInfo.length === 0) {
    throw new Error("Paket tidak ditemukan");
  }

  const [result] = await db('add_danus_purchase', [playerId, packageId])
  console.log("Result", result);

  return result;
}

const topupDanusController = async ({ set, jwt, cookie: { accessToken }, body }: { set: any, jwt: any, cookie: any, body: any }) => {
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
    const { packageId } = body;
    if (!packageId){
        set.status = 400;
        return { 
          success: false,
          message: "Paket tidak boleh kosong",
          error: [{
            field: "packageId is required",
            message: "Invalid request"
          }]
      };
    }
    const jwtPayload = await jwt.verify(accessTokenValue);
    const playerId = jwtPayload.sub.p_player_id;
    const result = await purchaseDanus({ playerId, packageId })
    const packageInfo = await getPackageDanusInfoDesc(packageId);
    const balance = await getBalance(playerId);
    set.status = 200;
    return {
      success: true,
      message: "Pembelian saldo danus berhasil",
      balance,
      data: result,
      description: packageInfo[0].description
    }
  } catch (error) {
    set.status = 400;
    return {
      success: false,
      message: "Error during topup",
      error: (error as Error).message
    }
  }
}

export { topupDanusController };

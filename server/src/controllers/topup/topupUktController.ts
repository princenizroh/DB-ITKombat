import { db } from "@/config/db";
import { getPackageUktInfoPrice, getPackageUktInfoDesc } from "./getPackagesController";
import { getBalance } from "@/controllers/store/getStoreController";

async function purchaseUkt({ playerId, packageId, paymentMethod }: { playerId: number, packageId: any, paymentMethod: any }) {
  const packageInfo = await getPackageUktInfoPrice(packageId);

  if (packageInfo.length === 0) {
    throw new Error("Paket tidak ditemukan");
  }
  const { price } = packageInfo[0];
  console.log("Price", price);
  const [result] = await db('add_ukt_purchase', [playerId, packageId, paymentMethod, price])

  return result;
}

const topupUktController = async ({ set, jwt, cookie: { accessToken }, body }: { set: any, jwt: any, cookie: any, body: any }) => {
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
    const { packageId, paymentMethod } = body;
    if (!packageId || !paymentMethod){
        set.status = 400;
        return { 
          success: false,
          message: 'Paket atau metode pembayaran tidak boleh kosong',
          error: [{
            field: "packageId or paymentMethod is required",
            message: "Invalid request"
          }]
      };
    }
    const jwtPayload = await jwt.verify(accessTokenValue);
    const playerId = jwtPayload.sub.p_player_id;
    const result = await purchaseUkt({ playerId, packageId, paymentMethod })
    const packageInfo = await getPackageUktInfoDesc(packageId);
    const balance = await getBalance(playerId);
    
    set.status = 200;
    return {
      success: true,
      message: "Topup saldo ukt berhasil",
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

export { topupUktController };

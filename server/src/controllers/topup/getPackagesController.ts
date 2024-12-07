
import { dbFunction } from "@/config/db";
import { getBalance } from "@/controllers/store/getStoreController";

export async function getPackageDanusInfoAmount(package_id: any) {
  const colums = ['danus_amount'];
  const packageInfo = await dbFunction('get_danus_packages', colums, ['package_id'], [package_id]);
  return packageInfo;
}

export async function getPackageDanusInfoDesc(package_id: any) {
  const columns = ['description'];
  const packageInfo = await dbFunction('get_danus_packages', columns, ['package_id'], [package_id]);
  return packageInfo;
}

export async function getPackageUktInfoPrice(package_id: any) {
  const columns = ['price'];
  const packageInfo = await dbFunction('get_ukt_packages', columns, ['package_id'], [package_id]);
  return packageInfo;
}

export async function getPackageUktInfoDesc(package_id: any) {
  const columns = ['description'];
  const packageInfo = await dbFunction('get_ukt_packages', columns, ['package_id'], [package_id]);
  return packageInfo;
}

async function getPaymentMethod() {
  const columns = ['method_id', 'method_name'];
  const paymentMethod = await dbFunction('get_payment_methods', columns);
  return paymentMethod;
}

async function getPackageInfo() {
  const columnsDanus = ['package_id', 'danus_amount', 'required_ukt', 'description'];
  const columnsUkt = ['package_id', 'ukt_amount', 'price', 'description'];
  const packageInfoDanus = await dbFunction('get_danus_packages', columnsDanus);
  const packageInfoUkt = await dbFunction('get_ukt_packages', columnsUkt);
  return { packageInfoDanus, packageInfoUkt };
}

const getPackagesController = async ({ set, jwt, cookie: { accessToken }, query}: { set: any, jwt: any, cookie: any, query: any}) => {
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

    const { type } = query;
    if (!type || (type !== 'danus' && type !== 'ukt')) {
      set.status = 400;
      return {
        success: false,
        message: "Paket harus diisi dengan 'danus' atau 'ukt'",
        error: [{
          field: "type",
          message: "Invalid type"
        }]
      }
    }

    const jwtPayload = await jwt.verify(accessTokenValue);
    const playerId = jwtPayload.sub.p_player_id;
    const result = await getPackageInfo();
    const balance = await getBalance(playerId);
    const paymentMethod = await getPaymentMethod();
    set.status = 200;
    return {
      success: true,
      message: "Mendapatkan paket danus dan ukt berhasil",
      balance,
      data: result,
      paymentMethod
    }
  } catch (error) {
    set.status = 400;
    return {
      success: false,
      message: "Error during get packages",
      error: (error as Error).message
    }
  }
}

export { getPackagesController };

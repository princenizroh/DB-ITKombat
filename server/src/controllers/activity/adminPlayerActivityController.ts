import { dbFunction } from '@/config/db'
async function getPlayerActivity(){ 
  const colums = ['player_id', 'username', 'type_activity', 'time_activity'];
  const result= await dbFunction("get_player_activity", colums);
  return result;
}

const adminPlayerActivityController = async ({ jwt, cookie: { accessToken }, set }: { jwt: any, cookie: any, set: any }) => { 
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
    const role = 'admin';
    const isAdmin = jwtPayload.sub.p_role;
    if (isAdmin !== role) {
      set.status = 401;
      return {
        success: false,
        message: "Anda bukan admin",
        error: [{
          field: "accessToken",
          message: "Unauthorized"
        }],
      }
    }

    const result = await getPlayerActivity();
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
}

export { adminPlayerActivityController }

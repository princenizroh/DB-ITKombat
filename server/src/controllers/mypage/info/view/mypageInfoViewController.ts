import { dbFunction } from "@/config/db";

async function getMyPageInfo(player_id: any) {
  const columns = ['username', 'email', 'password'];
  const result = await dbFunction('get_mypage_info', columns, ['player_id'], [player_id]);
  return result;
}

const mypageInfoViewController = async ({ jwt, cookie: { accessToken, accessMypageToken }, set}: { jwt: any, cookie: any, set: any }) => {
  try{
    const accessTokenValue = accessToken.value;
    const accessMypageTokenValue = accessMypageToken.value;
    if(!accessMypageTokenValue) { 
      set.status = 401;
      return {
        success: false,
        message: "Akses invalid",
        error: [{
          field: "accessMypageToken",
          message: "Unauthorized"
        }],
        redirect: "/mypage/info"
      }
    }
    const jwtPayload = await jwt.verify(accessTokenValue);
    console.log("Payload:", jwtPayload);
    const player_id = jwtPayload.sub.p_player_id;
    const [result] = await getMyPageInfo(player_id);
    set.status = 200;
    return {
      success: true,
      message: "Menampilkan informasi mypage berhasil",
      data: result
    }

  } catch (error) {
    set.status = 400;
    return {
      success: false,
      message: "Error during mypage info view",
      error: (error as Error).message
    }
  }
}

export { mypageInfoViewController }

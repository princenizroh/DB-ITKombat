const mypageInfoViewController = async ({ jwt, dbFunction, cookie: { accessToken }, set}: { jwt: any, dbFunction: any, cookie: any, set: any }) => {
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
    const id = jwtPayload.sub.p_player_id;
    const colums = ['player_id','username', 'email', 'password'];
    const [result] = await dbFunction('get_mypage_info', colums, 'player_id', id);
    set.status = 200;
    return {
      success: true,
      message: "View mypage info success",
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

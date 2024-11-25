const signoutController = async ({jwt, set, db, cookie, cookie: { accessToken, refreshToken }}: { jwt: any, set: any, db: any, cookie: any }) => {
  try {
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
    const refreshTokenValue = refreshToken.value;
    if (!accessTokenValue && !refreshTokenValue) {
      set.status = 400;
      return {
        success: false,
        message: "Signout gagal. Silahkan signin terlebih dahulu",
        error: [{
          field: "accessToken or refreshToken",
          message: "Invalid request"
        }]
      };
    } 
    accessToken.remove();
    refreshToken.remove();
    delete cookie.accessToken;
    delete cookie.refreshToken;
    const [result] = await db('signout', [id]);

    set.status = 200;
    return {
      success: true,
      message: "Player signout successfully",
      data: result
    } 
  } catch (error) {
    set.status = 400;
    return { 
      success: false,
      message: "Invalid Request",
      error: (error as Error).message
    };
  }
}

export { signoutController }

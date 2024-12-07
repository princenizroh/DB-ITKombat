const signoutController = async ({jwt, set, db, cookie, cookie: { accessToken, refreshToken, accessMypageToken }}: { jwt: any, set: any, db: any, cookie: any }) => {
  try {
    const accessTokenValue = accessToken.value;
    const refreshTokenValue = refreshToken.value;
    const accessMypageTokenValue = accessMypageToken.value;
    if (!accessTokenValue && !refreshTokenValue && ! accessMypageTokenValue) {
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
    const jwtPayload = await jwt.verify(accessTokenValue);
    const player_id = jwtPayload.sub.p_player_id;
    console.log("Payload:", jwtPayload);
    console.log("Player ID:", player_id);
    const [result] = await db('signout', [player_id]);
    console.log("Result:", result);
    accessToken.remove();
    refreshToken.remove();
    accessMypageToken.remove();
    delete cookie.accessToken;
    delete cookie.refreshToken;
    delete cookie.accessMypageToken;

    console.log("accessToken:", accessTokenValue);
    console.log("refreshToken:", refreshTokenValue);
    console.log("accessMypageToken:", accessMypageTokenValue);
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

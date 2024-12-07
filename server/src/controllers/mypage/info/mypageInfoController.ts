import { getExpTimestamp } from '@/utils/getExpTimestamp'
import { 
  ACCESS_TOKEN_EXP
} from "@/config/jwt"
const mypageInfoController = async ({ jwt, db, body, cookie: { accessToken, accessMypageToken }, set }: { db: any, jwt: any, body: any, cookie: any, set: any }) => {
  try {
    const accessTokenValue = accessToken.value;
    const jwtPayload = await jwt.verify(accessTokenValue);
    const id = jwtPayload.sub.p_player_id;
    const { password } = body;
    if (!password) {
      set.status = 400;
      return {
        success: false,
        message: "Password tidak boleh kosong",
        error: [{
          field: "password is required",
          error: "Invalid request"
        }]
      }
    }

    if (password.length < 8) {
      set.status = 422;
      return {
        success: false,
        message: "Password harus minimal 8 karakter",
        error: [{
          field: "password must be at least 8 characters",
          error: "Unprocessable Content"
        }]
      };
    }

    console.log("Payload:", jwtPayload);
    const [result] = await db('validate_password', [password, id]);
    console.log("Result:", result);
    if (!result){
      set.status = 400;
      return {
        success: false,
        message: "Invalid password",
        error: [{
          field: "password is invalid",
          error: "Invalid request"
        }]
      };
    };

    const payload = result;
    console.log("Payload:", payload);
    const exp = getExpTimestamp(ACCESS_TOKEN_EXP);
    const accessMypageJWTToken = await jwt.sign({
      sub: payload,
      exp: exp,
      httpOnly: true,
      maxAge: ACCESS_TOKEN_EXP,
      path: "/"
    })
    accessMypageToken.set({
      value: accessMypageJWTToken,
      httpOnly: true,
      maxAge: ACCESS_TOKEN_EXP,
      path: "/"
    })

    set.status = 200;
    // set.redirect = "/mypage/info/view";
    return {
      success: true,
      message: "Password valid",
      data: result,
      accessMyPageToken: accessMypageJWTToken,
      // redirect: "/mypage/info/view"
    }
  } catch (error) {
    set.status = 400;
    return {
      success: false,
      message: "Error during mypage info",
      error: (error as Error).message
    }
  }
}

export { mypageInfoController }

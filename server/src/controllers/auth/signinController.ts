import moment from 'moment-timezone'
import { getExpTimestamp } from '@/utils/getExpTimestamp'
import { 
  ACCESS_TOKEN_EXP, REFRESH_TOKEN_EXP
} from "@/config/jwt"


const signinController = async ({ jwt, db, body, set, cookie: { accessToken, refreshToken }}: { jwt: any, db: any, body: any, set: any, cookie: any }) => {
  const { username, password } = body;
  try {
    if (!username || !password) {
      set.status = 400;
      return {
        success: false,
        message: "Username atau password tidak boleh kosong",
        error: [{
          field: "username or password is required",
          error: "Invalid request"
        }]
      };
    }

    if (username.length < 2) {
      set.status = 422;
      return {
        success: false,
        message: "Username harus minimal 2 karakter",
        error: [{
          field: "username must be at least 2 characters",
          error: "Unprocessable Content"
        }]
      }
    }

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
    const [result] = await db('signin', [username, password]);
    console.log("Signin result:", result);

    if (!result) {
      set.status = 400;
      return {
        success: false,
        message: "Invalid username or password",
        error: [{
          field: "username or password is invalid",
          error: "Invalid request"
        }]
      };
    }

    const payload = result;
    console.log("Payload:", payload);
    const exp = getExpTimestamp(ACCESS_TOKEN_EXP);
    const timestamp = moment().tz('Asia/Kuala_Lumpur').format('YYYY-MM-DD HH:mm:ss');
    const accesJWTToken = await jwt.sign({          
        sub: payload, 
        exp: exp,
        httpOnly: true,
        maxAge: ACCESS_TOKEN_EXP,
        path: '/'
    })
    accessToken.set({
        value: accesJWTToken,
        httpOnly: true,
        maxAge: ACCESS_TOKEN_EXP,
        path: '/',
    });

    const refreshJWTToken = await jwt.sign({
      sub: payload,
      exp: exp,
      httpOnly: true,
      maxAge: REFRESH_TOKEN_EXP,
      path: '/',
    })

    refreshToken.set({
      value: refreshJWTToken,
      httpOnly: true,
      maxAge: REFRESH_TOKEN_EXP,
      path: '/',
    })

    set.status = 200;
    return {
      success: true,
      message: 'Signin successful',
      data: result,
      accesToken: accesJWTToken,
      timestamp
    };
  } catch (error) {
    set.status = 400;
    return {
      success: false,
      message: "Invalid Request",
      error: (error as Error).message
    };
  } 
}


export { signinController }


import moment from 'moment-timezone'
import { db } from "@/config/db";
import jwt from "@elysiajs/jwt"
import { getExpTimestamp } from "@/utils/getExpTimestamp"
import { 
  ACCESS_TOKEN_EXP,
  JWT_NAME,
  REFRESH_TOKEN_EXP
} from "@/config/constant-jwt"

const loginController = async ({ jwt, db, body, set, cookie: { accessToken }}: { jwt: any, db: any, body: any, set: any, cookie: any }) => {
    const { username, password } = body;
    try {
      const [result] = await db('login', [username, password]);
      console.log("Login result:", result);

      if (!result) {
          set.status = 400;
          return {
              success: false,
              message: "Invalid username or password",
              error: "Invalid request"
          };
      }

      const payload = result;
      console.log("Payload:", payload);
      const secret = Bun.env.JWT_SECRET!;
      console.log("Secret:", secret);
      const exp = getExpTimestamp(ACCESS_TOKEN_EXP);
      console.log("Exp:", exp);
      const timestamp = moment().tz('Asia/Kuala_Lumpur').format('YYYY-MM-DD HH:mm:ss');
      const accesJWTToken = await jwt.sign({          
          sub: payload, 
          exp: exp
      })
      console.log("JWT Token:", accesJWTToken);
      accessToken.set ({
          value: accesJWTToken,
          httpOnly: true,
          maxAge: ACCESS_TOKEN_EXP,
          path: '/',
        });
      return {
        success: true,
        message: 'Login successful',
        data: result,
        accesToken: accesJWTToken,
        timestamp
      };
    } catch (error) {
      console.error('Error during login:', error);
      return {
        success: false,
        message: "Login failed",
        error: (error as Error).message
      };
    } 
  }


export { loginController }


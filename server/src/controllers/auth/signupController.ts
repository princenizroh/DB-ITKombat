import moment from "moment-timezone"

const signupController = async ({ body, db, set }: { body: { username: string, email: string, password: string}, db: any, set: any }) =>{
  const { username, email, password } = body;
  console.log("body", body);

  try {
    if (!username || !password || !email) {
      set.status = 400;
      return {
        success: false,
        message: "Username atau password atau email tidak boleh kosong",
        error: [{
          field: "username or password or email is required",
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
          error: "Invalid request"
        }]
      }
    }
    
    const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
    if (!emailRegex.test(email)) {
      set.status = 422;
      return {
        success: false,
        message: "Format email tidak valid",
        error: [{
          field: "email must be valid",
          error: "Unprocessable Content"
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

    const [result] = await db("signup", 
      [username, email, password]
    );
    if (!result){
      set.status = 400;
      return {
        success: false,
        message: "Invalid username, email, or password",
        error: [{
          field: "username, email, or password is invalid",
          error: "Invalid request"
        }]
      };
    };

    const timestamp = moment().tz("Asia/Kuala_Lumpur").format("YYYY-MM-DD HH:mm:ss");
    
    set.status = 200;
    return {
      succes: true,
      message: "Player signup succesfully",
      data: result,
      timestamp
    }
  } catch (error){
    set.status = 400;
    return {
      succes: false,
      message: "invalid Request",
      error: (error as Error).message
    };
  };
}

export { signupController }

import { dbFunction} from "@/config/db";
const battlePlayerController = async ({ jwt, db, body, cookie: { accessToken }, set }: { db: any,jwt: any, body: any, cookie: any, set: any }) => {
  try {
   const accessTokenValue = accessToken.value;
    if (!accessTokenValue){
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
    console.log("Access Token:", accessTokenValue);
    const jwtPayload = await jwt.verify(accessTokenValue);
    const id = jwtPayload.sub.p_player_id;
    console.log("Payload:", jwtPayload);
    const { is_ranked } = body;
    if (!is_ranked) {
      set.status = 400;
      return {
        success: false,
        message: "Store id harus diisi",
        error: [{
          field: "store_id",
          message: "Invalid request"
        }]
      }
    }
    const [result] = await db('initiate_match', [id, is_ranked]);

    set.status = 200;
    return {
      success: true,
      message: "Match ditemukan dan telah selesai",
      data: result,
    }
  } catch (error) {
    set.status = 400;
    return {
      success: false,
      message: "Error during purchase item",
      error: (error as Error).message
    }
  }
}

const battlePlayerHistoryController = async ({ jwt, db, body, cookie: { accessToken }, set }: { db: any,jwt: any, body: any, cookie: any, set: any }) => {

}
export { battlePlayerController, battlePlayerHistoryController }

async function getPlayerProfile(player_id: number) {
  const columns = ['player_id', 'username', 'player_exp', 'player_level', 'player_rank', 'sk2pm', 'total_matches', 'total_wins', 'total_lose', 'win_rate'];
  const [profile] = await dbFunction('get_player_profile', columns, ['player_id'], [player_id]);
  return profile;
}

async function getMatchHistoryPlayer(username: any) {
  const columns = ['match_id', 'player_name', 'opponent_name', 'match_mode', 'sk2pm', 'match_date'];
  const history = await dbFunction('get_match_history_player', columns, ['player_name'], [username]);
  return history;
}

async function getMatchDetails(match_id: number) {
  const columns = ['match_id', 'player_name', 'opponent_name', 'match_mode', 'performance_points', 'performance_rating', 'sk2pm', 'danus_reward', 'rounds_won', 'total_rounds', 'total_hits_taken', 'match_date'];
  const [details] = await dbFunction('get_match_details', columns, ['match_id'], [match_id]);
  return details;
}

async function getLeaderboardsRank() {
  const columns = ['rank', 'username', 'sk2pm', 'player_level'];
  const leaderboard = await dbFunction('get_leaderboards_rank', columns);
  return leaderboard;
}

const getPlayerProfileController = async ({ jwt, cookie: { accessToken }, set }: { jwt: any, cookie: any, set: any }) => {
  try {
    const accessTokenValue = accessToken.value;
    if (!accessTokenValue){
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
    console.log("Payload:", jwtPayload);
    const player_id = jwtPayload.sub.p_player_id;

    const profile = await getPlayerProfile(player_id);
    set.status = 200;
    return {
      success: true,
      message: "Mendapatkan profil pemain berhasil",
      data: profile
    };
  } catch (error) {
    set.status = 400;
    return {
      success: false,
      message: "Error during get player profile",
      error: (error as Error).message
    };
  }
};

const getMatchHistoryPlayerController = async ({ jwt, cookie: { accessToken }, set }: { jwt: any, cookie: any, set: any }) => {
  try {
    const accessTokenValue = accessToken.value;
    if (!accessTokenValue){
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
    console.log("Payload:", jwtPayload);
    const username = jwtPayload.sub.p_username;


    const history = await getMatchHistoryPlayer(username);
    set.status = 200;
    return {
      success: true,
      message: "Mendapatkan riwayat pertandingan pemain berhasil",
      data: history
    };
  } catch (error) {
    set.status = 400;
    return {
      success: false,
      message: "Error during get match history",
      error: (error as Error).message
    };
  }
};

const getMatchDetailsController = async ({ query, set }: { query: any, set: any }) => {
  try {
    const { match_id } = query;
    if (!match_id) {
      set.status = 400;
      return {
        success: false,
        message: "match_id harus diisi",
        error: [{
          field: "match_id",
          message: "Invalid request"
        }]
      };
    }

    const details = await getMatchDetails(match_id);
    set.status = 200;
    return {
      success: true,
      message: "Mendapatkan detail pertandingan berhasil",
      data: details
    };
  } catch (error) {
    set.status = 400;
    return {
      success: false,
      message: "Error during get match details",
      error: (error as Error).message
    };
  }
};

const getLeaderboardsRankController = async ({ set }: { set: any }) => {
  try {
    const leaderboard = await getLeaderboardsRank();
    set.status = 200;
    return {
      success: true,
      message: "Mendapatkan leaderboard berhasil",
      data: leaderboard
    };
  } catch (error) {
    set.status = 400;
    return {
      success: false,
      message: "Error during get leaderboard",
      error: (error as Error).message
    };
  }
};
export { getPlayerProfileController, getMatchHistoryPlayerController, getMatchDetailsController, getLeaderboardsRankController };

import { getPlayerById } from '@/models/playerModel';

const getPlayerByIdController = async ({ params, set }) => {
  const playerId = Number(params.id);

  if (isNaN(playerId)) {
    set.status = 400;
    return { success: false, message: 'Invalid player ID' };
  }

  const player = await getPlayerById(playerId);

  if (!player) {
    set.status = 404;
    return { success: false, message: 'Player not found' };
  }
  console.log('getPlayerByIdController');

  return { 
    success: true, 
    message: 'Player found', 
    data: player 
  };
};

export { getPlayerByIdController };

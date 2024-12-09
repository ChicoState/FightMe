package com.backend.backend.fightGame;

import com.backend.backend.fightGame.Dto.FightGameDto;
import com.backend.backend.fightGame.Dto.UserMoveDto;

public interface FightGameService {
    FightGameDto createFightGame(long user1, long user2, long requestID);
    FightGameDto declareWinner(long id);
    FightGameDto setMove(long id, UserMoveDto userMoveDto);
    FightGameDto setNewTurn(long id);
}

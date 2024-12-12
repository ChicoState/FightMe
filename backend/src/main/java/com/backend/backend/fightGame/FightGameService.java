package com.backend.backend.fightGame;

import java.util.List;
import java.util.Map;

import com.backend.backend.fightGame.FightGame.Move;
import com.backend.backend.fightGame.Dto.FightGameDto;
import com.backend.backend.fightGame.Dto.UserMoveDto;

public interface FightGameService {
    FightGameDto createFightGame(long user1, long user2, long requesterID);
    FightGameDto getFightGame(long user1ID, long user2ID);
    FightGameDto declareWinner(long id);
    FightGameDto setMove(long id, UserMoveDto userMoveDto);
    Boolean doesMoveHit(Move user1Move, Move user2Move);
    FightGameDto setNewTurn(long id);
}

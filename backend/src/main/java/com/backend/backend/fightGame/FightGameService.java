package com.backend.backend.fightGame;

import org.springframework.web.bind.annotation.RequestBody;

import com.backend.backend.fightGame.Dto.FightGameDto;

public interface FightGameService {
    FightGameDto createFightGame(FightGameDto fightGameDto);
    FightGameDto declareWinner(long id);
}

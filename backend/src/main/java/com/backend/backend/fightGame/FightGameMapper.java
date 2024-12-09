package com.backend.backend.fightGame;

import java.util.List;
import java.util.stream.Collectors;

import com.backend.backend.fightGame.FightGame;
import com.backend.backend.fightGame.Dto.FightGameDto;
import com.backend.backend.user.UserMapper;
import com.backend.backend.user.Dto.UserDto;

public class FightGameMapper {
    public static FightGameDto mapToFightGameDto(FightGame fightGame) {
        return new FightGameDto(
            fightGame.getId(),
            fightGame.getWinnerID(),
            fightGame.getUser1(),
            fightGame.getUser2(),
            fightGame.getUser1HP(),
            fightGame.getUser2HP(),
            fightGame.getMoves()
        );
    }

    public static FightGame mapToFightGame(FightGameDto fightGameDto) {
        return new FightGame(
            fightGameDto.getId(),
            fightGameDto.getWinnerID(),
            fightGameDto.getUser1(),
            fightGameDto.getUser2(),
            fightGameDto.getUser1HP(),
            fightGameDto.getUser2HP(),
            fightGameDto.getMoves()
        );
    }
}

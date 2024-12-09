package com.backend.backend.fightGame;

import com.backend.backend.fightGame.Dto.FightGameDto;
import com.backend.backend.user.UserMapper;
import com.backend.backend.user.Dto.UserDto;
import com.backend.backend.user.User;

public class FightGameMapper {
    public static FightGameDto mapToFightGameDto(FightGame fightGame) {
        UserDto user1 = UserMapper.mapToUserDto(fightGame.getUser1());
        UserDto user2 = UserMapper.mapToUserDto(fightGame.getUser2());
        return new FightGameDto(
            fightGame.getId(),
            fightGame.getWinnerID(),
            fightGame.getRequesterID(),
            user1,
            user2,
            fightGame.getUser1HP(),
            fightGame.getUser2HP(),
            fightGame.getMoves()
        );
    }

    public static FightGame mapToFightGame(FightGameDto fightGameDto) {
        User user1 = UserMapper.mapToUser(fightGameDto.getUser1());
        User user2 = UserMapper.mapToUser(fightGameDto.getUser2());
        return new FightGame(
            fightGameDto.getId(),
            fightGameDto.getWinnerID(),
            fightGameDto.getRequesterID(),
            user1,
            user2,
            fightGameDto.getUser1HP(),
            fightGameDto.getUser2HP(),
            fightGameDto.getMoves()
        );
    }
}

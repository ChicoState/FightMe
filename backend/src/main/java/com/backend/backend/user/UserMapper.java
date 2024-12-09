package com.backend.backend.user;

import java.util.List;
import java.util.stream.Collectors;

import com.backend.backend.user.Dto.UserDto;
import com.backend.backend.fightGame.FightGameMapper;
import com.backend.backend.fightGame.FightGame;
import com.backend.backend.fightGame.Dto.FightGameDto;

public class UserMapper {
    public static UserDto mapToUserDto(User user) {
        List<FightGameDto> gameSessions = user.getGameSessions().stream().map((fightGame) -> FightGameMapper.mapToFightGameDto(fightGame)).collect(Collectors.toList());
        return new UserDto(
            user.getId(), 
            user.getName(),
            user.getDateCreated(), 
            user.getGamerScore(), 
            user.getAttackScore(),
            user.getDefenseScore(),
            user.getMagicScore(),
            user.getProfilePicture(),
            user.getUnlockedProfilePictures(),
            user.getTheme(),
            user.getUnlockedThemes(),
            user.getFriends(),
            gameSessions,
            user.getEmail(), 
            user.getPassword()
            );
    }

    public static User mapToUser(UserDto userDto) {
        List<FightGame> gameSessions = userDto.getGameSessions().stream().map((fightGame) -> FightGameMapper.mapToFightGame(fightGame)).collect(Collectors.toList());
        return new User(
            userDto.getId(), 
            userDto.getName(),
            userDto.getDateCreated(), 
            userDto.getGamerScore(), 
            userDto.getAttackScore(),
            userDto.getDefenseScore(),
            userDto.getMagicScore(),
            userDto.getProfilePicture(),
            userDto.getUnlockedProfilePictures(),
            userDto.getTheme(),
            userDto.getUnlockedThemes(),
            userDto.getFriends(),
            gameSessions,
            userDto.getEmail(), 
            userDto.getPassword()
            );
    }
}

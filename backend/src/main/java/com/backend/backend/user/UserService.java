package com.backend.backend.user;

import java.util.List;

import com.backend.backend.fightGame.Dto.FightGameDto;
import com.backend.backend.user.Dto.FriendDto;
import com.backend.backend.user.Dto.GamerScoreDto;
import com.backend.backend.user.Dto.StatsDto;
import com.backend.backend.user.Dto.ProfilePictureDto;
import com.backend.backend.user.Dto.ThemeDto;
import com.backend.backend.user.Dto.UserDto;

public interface UserService {
    UserDto createUser(UserDto userDto);

    UserDto getUserById(Long id);

    List<UserDto> getAllUsers();

    UserDto updateGamerScore(Long id, GamerScoreDto gamerScore);

    UserDto updateProfilePicture(Long id, ProfilePictureDto profilePicture);

    UserDto addProfilePicture(Long id, ProfilePictureDto profilePicture);

    UserDto updateTheme(Long id, ThemeDto theme);

    UserDto addTheme(Long id, ThemeDto theme);

    UserDto updateStats(Long id, StatsDto stats);

    void deleteUser(Long id);

    //Add a friend so update friends list
    UserDto addFriend(Long id, FriendDto friendId);

    UserDto addGameSession(Long user1ID, Long user2ID, FightGameDto fightGameDto);

    void deleteFriend(Long id, FriendDto friendId);

    List<Long> getFriends(Long id);

    List<UserDto> getSuggestedFriends(Long id);
    //Remove a user *Future
    //Edit a user *Future
}
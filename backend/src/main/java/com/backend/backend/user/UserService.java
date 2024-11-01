package com.backend.backend.user;

import java.util.List;

import com.backend.backend.user.Dto.FriendDto;
import com.backend.backend.user.Dto.GamerScoreDto;
import com.backend.backend.user.Dto.StatsDto;
import com.backend.backend.user.Dto.UserDto;

public interface UserService {
    UserDto createUser(UserDto userDto);

    UserDto getUserById(Long id);

    List<UserDto> getAllUsers();

    UserDto updateGamerScore(Long id, GamerScoreDto gamerScore);

    UserDto updateStats(Long id, StatsDto stats);

    void deleteUser(Long id);

    //Add a friend so update friends list
    UserDto addFriend(Long id, FriendDto friendId);

    void deleteFriend(Long id, FriendDto friendId);

    List<Long> getFriends(Long id);

    List<UserDto> getSuggestedFriends(Long id);
    //Remove a user *Future
    //Edit a user *Future
}
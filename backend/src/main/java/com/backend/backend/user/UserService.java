package com.backend.backend.user;

import java.util.List;

import com.backend.backend.user.Dto.GamerScoreDto;
import com.backend.backend.user.Dto.UserDto;

public interface UserService {
    UserDto createUser(UserDto userDto);

    UserDto getUserById(Long id);

    List<UserDto> getAllUsers();

    UserDto updateGamerScore(Long id, GamerScoreDto gamerScore);

    void deleteUser(Long id);

    //Remove a user *Future
    //Edit a user *Future
}
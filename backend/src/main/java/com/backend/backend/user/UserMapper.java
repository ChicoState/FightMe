package com.backend.backend.user;

import com.backend.backend.user.Dto.UserDto;

public class UserMapper {
    public static UserDto mapToUserDto(User user) {
        return new UserDto(
            user.getId(), 
            user.getName(),
            user.getDateCreated(), 
            user.getGamerScore(), 
            user.getFriends(), 
            user.getEmail(), 
            user.getPassword()
            );
    }

    public static User mapToUser(UserDto userDto) {
        return new User(
            userDto.getId(), 
            userDto.getName(),
            userDto.getDateCreated(), 
            userDto.getGamerScore(), 
            userDto.getFriends(), 
            userDto.getEmail(), 
            userDto.getPassword()
            );
    }
}

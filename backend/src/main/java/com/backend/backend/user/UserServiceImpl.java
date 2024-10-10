package com.backend.backend.user;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.backend.backend.ResourceNotFoundException;
import com.backend.backend.user.Dto.GamerScoreDto;
import com.backend.backend.user.Dto.UserDto;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class UserServiceImpl implements UserService {

    private UserRepository userRepository;


    @Override
    public UserDto createUser(UserDto userDto) {
        User user = UserMapper.mapToUser(userDto);
        User savedUser =userRepository.save(user);
        return UserMapper.mapToUserDto(savedUser);
    }


    @Override
    public UserDto getUserById(Long id) {
        User user =userRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + id));
        return UserMapper.mapToUserDto(user);
    }


    @Override
    public List<UserDto> getAllUsers() {
        List<User> users = userRepository.findAll();
        return users.stream().map((user) -> UserMapper.mapToUserDto(user)).collect(Collectors.toList());
    }

    @Override
    public UserDto updateGamerScore(Long id, GamerScoreDto gamerScore) {
        User user = userRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + id));
        user.setGamerScore(gamerScore.getGamerScore());
        User savedUser = userRepository.save(user);
        return UserMapper.mapToUserDto(savedUser);
    }

    @Override
    public void deleteUser(Long id) {
        User user = userRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + id));
        userRepository.delete(user);
    }
}

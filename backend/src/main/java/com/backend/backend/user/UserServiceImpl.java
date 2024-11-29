package com.backend.backend.user;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.backend.backend.ResourceNotFoundException;
import com.backend.backend.user.Dto.FriendDto;
import com.backend.backend.user.Dto.GamerScoreDto;
import com.backend.backend.user.Dto.ProfilePictureDto;
import com.backend.backend.user.Dto.StatsDto;
import com.backend.backend.user.Dto.ThemeDto;
import com.backend.backend.user.Dto.UserDto;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class UserServiceImpl implements UserService {

    private UserRepository userRepository;

    // START OF ALL CREATE

    @Override
    public UserDto createUser(UserDto userDto) {
        User user = UserMapper.mapToUser(userDto);
        User savedUser =userRepository.save(user);
        return UserMapper
        .mapToUserDto(savedUser);
    }
    // END OF ALL CREATE
    // ==============================================================================================================================================================================================================================================================================================================================================================================================================================================================================================
    // START OF ALL GET

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
    public List<Long> getFriends(Long id) {
        User user = userRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + id));
        return user.getFriends();
    }

    @Override
    public List<UserDto> getSuggestedFriends(Long id) {
        User user = userRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + id));
        List<User> myFriends = user.getFriends().stream().map((friendId) -> userRepository.findById(friendId).orElseThrow(() -> new ResourceNotFoundException("User not found" + friendId))).collect(Collectors.toList());
        List<User> everyUser = userRepository.findAll();
        List<UserDto> suggestedFriends = new ArrayList<>();
        for(User userr : everyUser){
            if(!myFriends.contains(userr) && userr.getId() != id){
                suggestedFriends.add(UserMapper.mapToUserDto(userr));
            }
        }        
        return suggestedFriends;
    }

    // END OF ALL GET 
    // ==============================================================================================================================================================================================================================================================================================================================================================================================================================================================================================
    // START OF ALL UPDATE

    @Override
    public UserDto updateGamerScore(Long id, GamerScoreDto gamerScore) {
        User user = userRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + id));
        user.setGamerScore(gamerScore.getGamerScore());
        User savedUser = userRepository.save(user);
        return UserMapper.mapToUserDto(savedUser);
    }

    @Override
    public UserDto updateProfilePicture(Long id, ProfilePictureDto profilePicture) {
        User user = userRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + id));
        user.setProfilePicture(profilePicture.getProfilePicture());
        User savedUser = userRepository.save(user);
        return UserMapper.mapToUserDto(savedUser);
    }

    @Override
    public UserDto updateTheme(Long id, ThemeDto theme) {
        User user = userRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + id));
        user.setTheme(theme.getTheme());
        User savedUser = userRepository.save(user);
        return UserMapper.mapToUserDto(savedUser);
    }

    @Override
    public UserDto updateStats(Long id, StatsDto stats) {
        User user = userRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + id));
        if(user.getAttackScore() == null && user.getDefenseScore() == null && user.getMagicScore() == null){
            user.setAttackScore(0);
            user.setDefenseScore(0);
            user.setMagicScore(0);
            userRepository.save(user);
        }
        user.setAttackScore(stats.getAttackScore());
        user.setDefenseScore(stats.getDefenseScore());
        user.setMagicScore(stats.getMagicScore());
        User savedUser = userRepository.save(user);
        return UserMapper.mapToUserDto(savedUser);
    }

    @Override
    public UserDto addFriend(Long id, FriendDto friendDto){
        User user = userRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + id));
        User friend = userRepository.findById(friendDto.getFriendId())
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + friendDto.getFriendId()));
        user.getFriends().add(friend.getId()); // changed to getid
        friend.getFriends().add(user.getId());
        User savedUser = userRepository.save(user);
        userRepository.save(friend);
        return UserMapper.mapToUserDto(savedUser);
    }

    @Override
    public UserDto addProfilePicture(Long id, ProfilePictureDto profilePicture) {
        User user = userRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + id));
        user.getUnlockedProfilePictures().add(profilePicture.getProfilePicture());
        User savedUser = userRepository.save(user);
        return UserMapper.mapToUserDto(savedUser);
    }

    @Override
    public UserDto addTheme(Long id, ThemeDto theme) {
        User user = userRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + id));
        user.getUnlockedThemes().add(theme.getTheme());
        User savedUser = userRepository.save(user);
        return UserMapper.mapToUserDto(savedUser);
    }

    // END OF ALL UPDATE
    // ==============================================================================================================================================================================================================================================================================================================================================================================================================================================================================================
    // START OF ALL DELETE

    @Override
    public void deleteUser(Long id) {
        User user = userRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + id));
        userRepository.delete(user);
    }

    @Override
    public void deleteFriend(Long id, FriendDto friendDto) {
        User user = userRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + id));
        User friend = userRepository.findById(friendDto.getFriendId())
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + friendDto.getFriendId()));
        user.getFriends().remove(friend.getId()); //changed to getid
        friend.getFriends().remove(user.getId());
        userRepository.save(user);
        userRepository.save(friend);
    }
}

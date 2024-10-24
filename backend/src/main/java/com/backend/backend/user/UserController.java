package com.backend.backend.user;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.backend.backend.user.Dto.FriendDto;
import com.backend.backend.user.Dto.GamerScoreDto;
import com.backend.backend.user.Dto.StatsDto;
import com.backend.backend.user.Dto.UserDto;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;

import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;



@RestController
@RequestMapping("/api/users")
@AllArgsConstructor
@CrossOrigin(origins = "http://localhost:60966")  //this changes every time i run flutter
public class UserController {
    private UserService userService;

    @PostMapping
    public ResponseEntity<UserDto> createUser(@RequestBody UserDto userDto) {
        UserDto savedUser = userService.createUser(userDto);
        return new ResponseEntity<>(savedUser, HttpStatus.CREATED);
    }

    @GetMapping("{id}")
    public ResponseEntity<UserDto> getUserById(@PathVariable("id") Long id) {
        UserDto userDto = userService.getUserById(id);
        return new ResponseEntity<>(userDto, HttpStatus.OK);
    }

    @GetMapping
    public ResponseEntity<List<UserDto>> getAllUsers() {
        List<UserDto> users = userService.getAllUsers();
        return new ResponseEntity<>(users, HttpStatus.OK);
    }
    
    @PutMapping("{id}/gamerScore")
    public ResponseEntity<UserDto> updateGamerScore(@PathVariable("id") Long id, @RequestBody GamerScoreDto GamerScoreDto) {
        UserDto updatedUser = userService.updateGamerScore(id, GamerScoreDto);
        return new ResponseEntity<>(updatedUser, HttpStatus.OK);
    }

    @PutMapping("{id}/stats")
    public ResponseEntity<UserDto> updateStats(@PathVariable("id") Long id, @RequestBody StatsDto statsDto) {
        UserDto updatedUser = userService.updateStats(id, statsDto);
        return new ResponseEntity<>(updatedUser, HttpStatus.OK);
    }

    @PutMapping("{id}/friends")
    public ResponseEntity<UserDto> addFriend(@PathVariable("id") Long id, @RequestBody FriendDto friendDto) {
        UserDto updatedUser = userService.addFriend(id, friendDto);
        return new ResponseEntity<>(updatedUser, HttpStatus.OK);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<String> deleteUser(@PathVariable("id") Long id) {
        userService.deleteUser(id);
        return ResponseEntity.ok("User Deleted");
    }

    @DeleteMapping("{id}/friends")
    public ResponseEntity<String> deleteFriend(@PathVariable("id") Long id, @RequestBody FriendDto friendDto) {
        userService.deleteFriend(id, friendDto);
        return ResponseEntity.ok("Friend Deleted");
    }
}

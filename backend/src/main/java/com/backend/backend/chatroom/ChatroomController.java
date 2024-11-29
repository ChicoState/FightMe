package com.backend.backend.chatroom;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.backend.backend.chatroom.Dto.ChatroomCreateDto;
import com.backend.backend.chatroom.Dto.ChatroomDto;
import com.backend.backend.user.UserService;
import com.backend.backend.user.Dto.UserDto;

import lombok.AllArgsConstructor;

@RestController
@RequestMapping("/api/chatroom")
@AllArgsConstructor
// @CrossOrigin(origins = "http://localhost:60966")  
@CrossOrigin(origins = "*")
public class ChatroomController {
    private ChatroomService chatroomService;
    private UserService userService;

    @PostMapping        //dont use this, its more complicated but still works
    public ResponseEntity<ChatroomDto> createChatroom(@RequestBody ChatroomDto chatroomDto) {
        ChatroomDto savedChatroom = chatroomService.createChatroom(chatroomDto);
        return new ResponseEntity<>(savedChatroom, HttpStatus.CREATED);
    }

    @PostMapping("/create")
    public ResponseEntity<ChatroomDto> createChatroom(@RequestBody ChatroomCreateDto chatroomCreateDto) {
        List<UserDto> users = chatroomCreateDto.getUserIds().stream().map((id) -> userService.getUserById(id)).collect(Collectors.toList());
        if(users.size() != chatroomCreateDto.getUserIds().size()){
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
        ChatroomDto savedChatroom = chatroomService.createChatroom(chatroomCreateDto, users);
        return new ResponseEntity<>(savedChatroom, HttpStatus.CREATED);
    }

    @GetMapping("{id}")
    public ResponseEntity<ChatroomDto> getChatroomById(@PathVariable("id") Long id) {
        ChatroomDto chatroomDto = chatroomService.getChatroomById(id);
        return new ResponseEntity<>(chatroomDto, HttpStatus.OK);
    }

    @GetMapping("/user/{id}")
    public ResponseEntity<List<ChatroomDto>> getChatroomsByUserId(@PathVariable("id") Long id) {
        List<ChatroomDto> chatroomDto = chatroomService.getChatroomsByUserId(id);
        return new ResponseEntity<>(chatroomDto, HttpStatus.OK);
    }

    @GetMapping
    public ResponseEntity<List<ChatroomDto>> getAllChatrooms() {
        List<ChatroomDto> chatrooms = chatroomService.getAllChatrooms();
        return new ResponseEntity<>(chatrooms, HttpStatus.OK);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<Void> deleteChatroom(@PathVariable("id") Long id) {
        chatroomService.deleteChatroom(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

}

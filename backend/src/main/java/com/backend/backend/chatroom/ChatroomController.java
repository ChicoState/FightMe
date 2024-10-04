package com.backend.backend.chatroom;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.AllArgsConstructor;

@RestController
@RequestMapping("/api/chatroom")
@AllArgsConstructor
@CrossOrigin(origins = "http://localhost:60966")  
public class ChatroomController {
    private ChatroomService chatroomService;

    @PostMapping
    public ResponseEntity<ChatroomDto> createChatroom(@RequestBody ChatroomDto chatroomDto) {
        ChatroomDto savedChatroom = chatroomService.createChatroom(chatroomDto);
        return new ResponseEntity<>(savedChatroom, HttpStatus.CREATED);
    }

    @GetMapping("{id}")
    public ResponseEntity<ChatroomDto> getChatroomById(@PathVariable("id") Long id) {
        ChatroomDto chatroomDto = chatroomService.getChatroomById(id);
        return new ResponseEntity<>(chatroomDto, HttpStatus.OK);
    }

    @GetMapping
    public ResponseEntity<List<ChatroomDto>> getAllChatrooms() {
        List<ChatroomDto> chatrooms = chatroomService.getAllChatrooms();
        return new ResponseEntity<>(chatrooms, HttpStatus.OK);
    }

}

package com.backend.backend.message;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;



@RestController
@RequestMapping("/api/messages")
@AllArgsConstructor
@CrossOrigin(origins = "http://localhost:60966")
public class MessageController {
    private MessageService messageService;

    @PostMapping
    public ResponseEntity<MessageDto> createMessage(@RequestBody MessageDto messageDto) {
        MessageDto savedMessage = messageService.CreateMessage(messageDto);
        return new ResponseEntity<>(savedMessage, HttpStatus.CREATED);
    }

    @GetMapping("{chatroomId}")
    public ResponseEntity<List<MessageDto>> getAllMessagesByChatroomId(@PathVariable long chatroomId) {
        List<MessageDto> messages = messageService.getAllMessagesByChatroomId(chatroomId);
        return new ResponseEntity<>(messages, HttpStatus.OK);
    }
    
}

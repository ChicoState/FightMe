package com.backend.backend.websocket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.backend.backend.chatroom.ChatroomService;
import com.backend.backend.message.MessageDto;
import com.backend.backend.message.MessageService;

@Controller
public class MessageControllerWS {

    @Autowired
    private SimpMessagingTemplate SimpleMessagingTemplate;
    @Autowired
    private MessageService messageService;
    @Autowired
    private ChatroomService chatroomService;

    @MessageMapping("/chat.sendMessage")
    @SendTo("/topic/chatroom/{chatroomId}")
    public void sendMessage(MessageDto messageDto) {
        long chatroomId = messageDto.getChatroomId();
        String content = messageDto.getContent();

        chatroomService.getChatroomById(chatroomId)
                .orElseThrow(() -> new RuntimeException("Chatroom not found: " + chatroomId));
}


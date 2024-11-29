package com.backend.backend.websocket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
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
    private SimpMessagingTemplate simpleMessagingTemplate;
    @Autowired
    private MessageService messageService;

    @MessageMapping("/chat.sendMessage")
    public void sendMessage(@DestinationVariable Long chatroomId, MessageDto messageDto) {
        messageDto.setChatroomId(chatroomId);
        
        MessageDto savedMessage = messageService.CreateMessage(messageDto);
        simpleMessagingTemplate.convertAndSend("/topic/chatroom/" + chatroomId, savedMessage);
    }
}


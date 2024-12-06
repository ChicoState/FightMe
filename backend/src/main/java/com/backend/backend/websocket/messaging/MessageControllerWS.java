package com.backend.backend.websocket.messaging;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.backend.backend.message.MessageDto;
import com.backend.backend.message.MessageService;

@Controller
public class MessageControllerWS {

    @Autowired
    private SimpMessagingTemplate simpleMessagingTemplate;
    @Autowired
    private MessageService messageService;

    @MessageMapping("/chatroom/{chatroomId}/sendMessage")
    public void sendMessage(@DestinationVariable Long chatroomId, @Payload MessageDto messageDto) {
        messageDto.setChatroomId(chatroomId);
        
        MessageDto savedMessage = messageService.CreateMessage(messageDto);
        simpleMessagingTemplate.convertAndSend("/topic/chatroom/" + chatroomId, savedMessage);
    }
}


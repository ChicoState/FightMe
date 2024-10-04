package com.backend.backend.message;

import java.util.List;

public interface MessageService {

    //Create a message with websockets somehow

    //Remove a message *Future

    //Edit a message *Future

    MessageDto CreateMessage(MessageDto messageDto);
    
    List<MessageDto> getAllMessagesByChatroomId(long chatroomId);
}

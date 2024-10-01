package com.backend.backend.message;

import java.util.List;

public interface MessageService {

    //Create a message with websockets somehow

    //Remove a message *Future

    //Edit a message *Future

    List<MessageDto> getMessagesByChatroom(Long chatroomId);
}

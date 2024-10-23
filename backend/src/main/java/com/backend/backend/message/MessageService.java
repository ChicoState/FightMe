package com.backend.backend.message;

import java.util.List;

public interface MessageService {

    MessageDto CreateMessage(MessageDto messageDto);
    
    List<MessageDto> getAllMessagesByChatroomId(long chatroomId);

    MessageDto getLatestMessageInChatroomId(long chatroomId);

    void markLatestMessageAsRead(long chatroomId);
}

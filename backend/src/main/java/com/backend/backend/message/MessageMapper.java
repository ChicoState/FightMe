package com.backend.backend.message;

public class MessageMapper {
    public static MessageDto mapToMessageDto(Message message) {
        return new MessageDto(
            message.getId(), 
            message.getToId(), 
            message.getFromId(), 
            message.getContent(), 
            message.getIsRead(), 
            message.getTimeStamp(),
            message.getChatroomId()
            );
    }

    public static Message mapToMessage(MessageDto messageDto) {
        return new Message(
            messageDto.getId(), 
            messageDto.getToId(), 
            messageDto.getFromId(), 
            messageDto.getContent(), 
            messageDto.getIsRead(), 
            messageDto.getTimeStamp(),
            messageDto.getChatroomId()
            );
    }
}

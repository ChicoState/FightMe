package com.backend.backend.message;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.backend.backend.ResourceNotFoundException;
import com.backend.backend.chatroom.Chatroom;
import com.backend.backend.chatroom.ChatroomRepository;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class MessageServiceImpl implements MessageService {
    
    private MessageRepository messageRepository;
    private ChatroomRepository chatroomRepository;

    @Override
    public MessageDto CreateMessage(MessageDto messageDto) {
        chatroomRepository.findById(messageDto.getChatroomId())
        .orElseThrow(() -> new ResourceNotFoundException("Chatroom not found: " + messageDto.getChatroomId()));

        Message message = MessageMapper.mapToMessage(messageDto);

        Message savedMessage = messageRepository.save(message);
        return MessageMapper.mapToMessageDto(savedMessage);
    }

    @Override
    public List<MessageDto> getAllMessagesByChatroomId(long chatroomId) {
        Chatroom chatroom = chatroomRepository.findById(chatroomId)
        .orElseThrow(() -> new ResourceNotFoundException("Chatroom not found: " + chatroomId));

        List<Message> messages = chatroom.getConversations();
        return messages.stream().map((message) -> MessageMapper.mapToMessageDto(message)).collect(Collectors.toList());
    }

    @Override
    public MessageDto getLatestMessageInChatroomId(long chatroomId){
        Chatroom chatroom = chatroomRepository.findById(chatroomId)
        .orElseThrow(() -> new ResourceNotFoundException("Chatroom not found: " + chatroomId));
        Message latestMessage = chatroom.getConversations().get(chatroom.getConversations().size() - 1); //gets the latest message
        return MessageMapper.mapToMessageDto(latestMessage);
    }

    @Override
    public void markLatestMessageAsRead(long chatroomId){
        MessageDto message = getLatestMessageInChatroomId(chatroomId);      //gets teh latest message
        message.setIsRead(true);        //sets the read reciept to read
        Message savedMessage = MessageMapper.mapToMessage(message);
        messageRepository.save(savedMessage);   //saves it to the repository
    }
}

package com.backend.backend.chatroom;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.backend.backend.ResourceNotFoundException;
import com.backend.backend.chatroom.Dto.ChatroomCreateDto;
import com.backend.backend.chatroom.Dto.ChatroomDto;
import com.backend.backend.message.MessageDto;
import com.backend.backend.message.MessageMapper;
import com.backend.backend.user.User;
import com.backend.backend.user.UserRepository;
import com.backend.backend.user.Dto.UserDto;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class ChatroomServiceImpl implements ChatroomService {
    
    private ChatroomRepository chatroomRepository;
    private UserRepository userRepository;

    @Override
    public ChatroomDto createChatroom(ChatroomDto chatroomDto) {
        Chatroom chatroom = ChatroomMapper.mapToChatroom(chatroomDto);
        Chatroom savedChatroom = chatroomRepository.save(chatroom);
        return ChatroomMapper.mapToChatroomDto(savedChatroom);
    }

    @Override
    public ChatroomDto createChatroom(ChatroomCreateDto chatroomCreateDto, List<UserDto> users) {
        Chatroom chatroom = ChatroomMapper.mapToChatroom(chatroomCreateDto, users);
        Chatroom savedChatroom = chatroomRepository.save(chatroom);
        return ChatroomMapper.mapToChatroomDto(savedChatroom);
    }

    @Override
    public ChatroomDto getChatroomById(Long id) {
        Chatroom chatroom = chatroomRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("Chatroom not found" + id));
        return ChatroomMapper.mapToChatroomDto(chatroom);
    }

    @Override
    public List<ChatroomDto> getAllChatrooms() {
        List<Chatroom> chatrooms = chatroomRepository.findAll();
        return chatrooms.stream().map((chatroom) -> ChatroomMapper.mapToChatroomDto(chatroom)).collect(Collectors.toList());
    }

    @Override
    public List<ChatroomDto> getChatroomsByUserId(Long id) {
        User user = userRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + id));
        List<Chatroom> chatrooms = chatroomRepository.findByUsers(user);
        return chatrooms.stream().map((chatroom) -> ChatroomMapper.mapToChatroomDto(chatroom)).collect(Collectors.toList());
    }

    @Override
    public List<MessageDto> getMessagesByChatroomId(Long id) {
        Chatroom chatroom = chatroomRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("Chatroom not found" + id));
        return chatroom.getConversations().stream().map((message) -> MessageMapper.mapToMessageDto(message)).collect(Collectors.toList());
    }

    @Override
    public void deleteChatroom(Long id) {
        Chatroom chatroom = chatroomRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("Chatroom not found " + id));
        chatroomRepository.delete(chatroom);
    }
}

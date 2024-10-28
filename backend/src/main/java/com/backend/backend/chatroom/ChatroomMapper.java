package com.backend.backend.chatroom;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import com.backend.backend.ResourceNotFoundException;
import com.backend.backend.chatroom.Dto.ChatroomCreateDto;
import com.backend.backend.chatroom.Dto.ChatroomDto;
import com.backend.backend.message.Message;
import com.backend.backend.message.MessageDto;
import com.backend.backend.message.MessageMapper;
import com.backend.backend.user.User;
import com.backend.backend.user.UserMapper;
import com.backend.backend.user.UserServiceImpl;
import com.backend.backend.user.Dto.UserDto;

public class ChatroomMapper {
    
    public static ChatroomDto mapToChatroomDto(Chatroom chatroom) {

        List<UserDto> users = chatroom.getUsers().stream().map((user) -> UserMapper.mapToUserDto(user)).collect(Collectors.toList());
        List<MessageDto> conversations = chatroom.getConversations().stream().map((message) -> MessageMapper.mapToMessageDto(message)).collect(Collectors.toList());
        return new ChatroomDto(chatroom.getId(), users, conversations);
    }

    public static Chatroom mapToChatroom(ChatroomDto chatroomDto) {

        List<User> users = chatroomDto.getUsers().stream().map((user) -> UserMapper.mapToUser(user)).collect(Collectors.toList());
        List<Message> conversations = chatroomDto.getConversations().stream().map((message) -> MessageMapper.mapToMessage(message)).collect(Collectors.toList());
        return new Chatroom(chatroomDto.getId(), users, conversations);
    }



    
    public static ChatroomCreateDto mapToChatroomCreateDto(Chatroom chatroom) {     //converts chatroom to ChatroomCreateDto

        List<Long> users = chatroom.getUsers().stream().map((user) -> user.getId()).collect(Collectors.toList());
        return new ChatroomCreateDto(chatroom.getId(), users);
    }
    public static Chatroom mapToChatroom(ChatroomCreateDto chatroomCreateDto, List<UserDto> users) {         //convert ChatroomCreateDto to Chatroom... should turn id into actual user from database
        List<User> userList = users.stream().map((user) -> UserMapper.mapToUser(user)).collect(Collectors.toList());
        return new Chatroom(chatroomCreateDto.getId(), userList, new ArrayList<>());
    }
}


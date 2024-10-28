package com.backend.backend.chatroom;

import java.util.List;

import com.backend.backend.chatroom.Dto.ChatroomCreateDto;
import com.backend.backend.chatroom.Dto.ChatroomDto;
import com.backend.backend.message.MessageDto;
import com.backend.backend.user.Dto.UserDto;

public interface ChatroomService {

    ChatroomDto createChatroom(ChatroomDto chatroomDto);
    ChatroomDto createChatroom(ChatroomCreateDto chatroomCreateDto, List<UserDto> users);
    ChatroomDto getChatroomById(Long id);
    List<ChatroomDto> getAllChatrooms();
    List<ChatroomDto> getChatroomsByUserId(Long id);
    List<MessageDto> getMessagesByChatroomId(Long id);
    void deleteChatroom(Long id);
}

package com.backend.backend.chatroom;

import java.util.List;

import com.backend.backend.chatroom.Dto.ChatroomCreateDto;
import com.backend.backend.chatroom.Dto.ChatroomDto;
import com.backend.backend.message.MessageDto;
import com.backend.backend.user.User;
import com.backend.backend.user.Dto.UserDto;

public interface ChatroomService {

    ChatroomDto createChatroom(ChatroomDto chatroomDto);
    ChatroomDto createChatroom(ChatroomCreateDto chatroomCreateDto, List<UserDto> users);
    ChatroomDto getChatroomById(Long id);
    List<ChatroomDto> getAllChatrooms();
    List<ChatroomDto> getChatroomsByUser(User user);

    List<MessageDto> getMessagesByChatroomId(Long id);

    //Remove a chatroom *Future
    void deleteChatroom(Long id);
}

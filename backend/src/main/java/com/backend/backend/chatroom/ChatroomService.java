package com.backend.backend.chatroom;

import java.util.List;

import com.backend.backend.user.User;

public interface ChatroomService {

    ChatroomDto createChatroom(ChatroomDto chatroomDto);
    ChatroomDto getChatroomById(Long id);
    List<ChatroomDto> getAllChatrooms();
    List<ChatroomDto> getChatroomsByUser(User user);

    //Remove a chatroom *Future
}

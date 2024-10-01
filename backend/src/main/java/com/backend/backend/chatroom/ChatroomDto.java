package com.backend.backend.chatroom;

import java.util.List;

import com.backend.backend.message.Message;
import com.backend.backend.user.User;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ChatroomDto {
    private Long id;
    private List<User> users;
    private List<Message> conversations;
}

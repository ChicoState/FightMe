package com.backend.backend.chatroom.Dto;

import java.util.ArrayList;
import java.util.List;
import com.backend.backend.message.MessageDto;
import com.backend.backend.user.Dto.UserDto;

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
    private List<UserDto> users;
    private List<MessageDto> conversations = new ArrayList<>();
}

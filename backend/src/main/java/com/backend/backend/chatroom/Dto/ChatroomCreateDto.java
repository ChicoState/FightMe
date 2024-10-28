package com.backend.backend.chatroom.Dto;

import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class ChatroomCreateDto {
    private long id; 
    private List<Long> userIds;
}


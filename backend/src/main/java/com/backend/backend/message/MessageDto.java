package com.backend.backend.message;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MessageDto {
    private long id;
    private long toId;
    private long fromId;
    private String content;
    private Boolean isRead;
    private long timeStamp;
    private long chatroomId;
}

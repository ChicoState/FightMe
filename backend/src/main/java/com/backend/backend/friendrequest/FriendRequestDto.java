package com.backend.backend.friendrequest;

import com.backend.backend.friendrequest.FriendRequest.Status;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class FriendRequestDto {
    private Long id;
    private Long fromUserID;
    private Long toUserID;
    private Status status;
}

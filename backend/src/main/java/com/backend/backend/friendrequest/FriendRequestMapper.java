package com.backend.backend.friendrequest;

public class FriendRequestMapper {
    public static FriendRequestDto mapToFriendRequestDto(FriendRequest friendRequest) {
        return new FriendRequestDto(
            friendRequest.getId(),
            friendRequest.getFromUserID(),
            friendRequest.getToUserID(),
            friendRequest.getStatus()
        );
    }

    public static FriendRequest mapToFriendRequest(FriendRequestDto friendRequestDto) {
        return new FriendRequest(
            friendRequestDto.getId(),
            friendRequestDto.getFromUserID(),
            friendRequestDto.getToUserID(),
            friendRequestDto.getStatus()
        );
    }
}

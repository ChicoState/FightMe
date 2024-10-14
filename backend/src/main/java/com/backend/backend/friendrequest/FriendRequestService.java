package com.backend.backend.friendrequest;

import java.util.List;

public interface FriendRequestService {
    FriendRequestDto sendFriendRequest(Long fromUserID, Long toUserID);
    List<FriendRequestDto> getAllFriendRequestForUser(Long userID);
    FriendRequestDto acceptFriendRequest(Long requestID);
    FriendRequestDto rejectFriendRequest(Long requestID);
}

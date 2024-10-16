package com.backend.backend.friendrequest;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.backend.backend.ResourceNotFoundException;
import com.backend.backend.user.User;
import com.backend.backend.user.UserRepository;
import com.backend.backend.user.UserService;
import com.backend.backend.user.Dto.FriendDto;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class FriendRequestServiceImpl implements FriendRequestService {

    private FriendRequestRepository friendRequestRepository;
    private UserService userService;
    private UserRepository userRepository;


    @Override
    public FriendRequestDto sendFriendRequest(Long fromUserID, Long toUserID) { //in the future add implementation for checking dupes
        User fromUser = userRepository.findById(fromUserID)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + fromUserID));
        User toUser = userRepository.findById(toUserID)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + toUserID));
        if (fromUser.getFriends().contains(toUserID) || toUser.getFriends().contains(fromUserID)) {
            throw new ResourceNotFoundException("User already friended with this user");
        }
        FriendRequest friendRequest = new FriendRequest();
        friendRequest.setFromUserID(fromUserID);
        friendRequest.setToUserID(toUserID);
        friendRequest.setStatus(FriendRequest.Status.PENDING);
        friendRequest = friendRequestRepository.save(friendRequest);
        return FriendRequestMapper.mapToFriendRequestDto(friendRequest);
    }

    @Override
    public List<FriendRequestDto> getAllFriendRequestForUser(Long userID) {
        userRepository.findById(userID)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + userID));
        List<FriendRequest> friendRequests = friendRequestRepository.findByToUserID(userID);
        return friendRequests.stream().map((friendRequest) -> FriendRequestMapper.mapToFriendRequestDto(friendRequest)).collect(Collectors.toList());
    }

    @Override
    public FriendRequestDto acceptFriendRequest(Long requestID) {
        FriendRequest friendRequest = friendRequestRepository.findById(requestID)
        .orElseThrow(() -> new ResourceNotFoundException("FriendRequest not found" + requestID));
        friendRequest.setStatus(FriendRequest.Status.ACCEPTED);
        friendRequestRepository.save(friendRequest);
        userService.addFriend(friendRequest.getFromUserID(), new FriendDto(friendRequest.getToUserID()));
        return FriendRequestMapper.mapToFriendRequestDto(friendRequest);
    }

    @Override
    public FriendRequestDto rejectFriendRequest(Long requestID) { //needs to be tweaked later. only rejects from one way
        FriendRequest friendRequest = friendRequestRepository.findById(requestID)
        .orElseThrow(() -> new ResourceNotFoundException("FriendRequest not found" + requestID));
        friendRequest.setStatus(FriendRequest.Status.REJECTED);
        friendRequestRepository.save(friendRequest);
        return FriendRequestMapper.mapToFriendRequestDto(friendRequest);
    }
    
}

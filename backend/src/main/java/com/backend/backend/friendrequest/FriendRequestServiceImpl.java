package com.backend.backend.friendrequest;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.backend.backend.ResourceNotFoundException;
import com.backend.backend.user.User;
import com.backend.backend.user.UserRepository;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class FriendRequestServiceImpl implements FriendRequestService {

    private FriendRequestRepository friendRequestRepository;
    private UserRepository userRepository;


    @Override
    public FriendRequestDto sendFriendRequest(Long fromUserID, Long toUserID) {
        User fromUser = userRepository.findById(fromUserID)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + fromUserID));
        User toUser = userRepository.findById(toUserID)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + toUserID));
        if (fromUser.getFriends().contains(toUserID) || toUser.getFriends().contains(fromUserID)) {
            throw new ResourceNotFoundException("User already friended with this user");
        }

        List<FriendRequest> existingRejectedRequests = friendRequestRepository
        .findByFromUserIDAndToUserIDAndStatus(fromUserID, toUserID, FriendRequest.Status.REJECTED);
        if(!existingRejectedRequests.isEmpty()) {
            throw new ResourceNotFoundException("You've been rejected before and cant send friend request");
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
    public List<FriendRequestDto> getAllFriendRequestFromUser(Long userID) {
        userRepository.findById(userID)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + userID));
        List<FriendRequest> friendRequests = friendRequestRepository.findByFromUserID(userID);
        return friendRequests.stream().map((friendRequest) -> FriendRequestMapper.mapToFriendRequestDto(friendRequest)).collect(Collectors.toList());
    }

    @Override
    public FriendRequestDto acceptFriendRequest(Long requestID) {
        FriendRequest friendRequest = friendRequestRepository.findById(requestID)
        .orElseThrow(() -> new ResourceNotFoundException("FriendRequest not found" + requestID));
        friendRequest.setStatus(FriendRequest.Status.ACCEPTED);
        /* List<FriendRequest> friendRequestViceVersa = friendRequestRepository.findByFromUserID(friendRequest.getToUserID());
        if(friendRequestViceVersa.size() == 0) {
            sendFriendRequest(friendRequest.getToUserID(), friendRequest.getFromUserID());
        } */
        friendRequestRepository.save(friendRequest);
        // userService.addFriend(friendRequest.getFromUserID(), new FriendDto(friendRequest.getToUserID()));
        return FriendRequestMapper.mapToFriendRequestDto(friendRequest);
    }

    @Override
    public FriendRequestDto rejectFriendRequest(Long requestID) { //needs to be tweaked later. only rejects from one way
        FriendRequest friendRequest = friendRequestRepository.findById(requestID)
        .orElseThrow(() -> new ResourceNotFoundException("FriendRequest not found" + requestID));
        friendRequest.setStatus(FriendRequest.Status.REJECTED);
        List<FriendRequest> friendRequestViceVersa = friendRequestRepository.findByFromUserID(friendRequest.getToUserID());
        if(friendRequestViceVersa.size() != 0) {
            friendRequestViceVersa.get(0).setStatus(FriendRequest.Status.REJECTED);
            friendRequestRepository.save(friendRequestViceVersa.get(0));
        }
        friendRequestRepository.save(friendRequest);
        return FriendRequestMapper.mapToFriendRequestDto(friendRequest);
    }

    @Override
    public FriendRequestDto getFriendRequestBetween(Long fromUserID, Long toUserID) {//in the future add implementation for checking dupes
        FriendRequest friendRequest = friendRequestRepository.findByFromUserIDAndToUserID(fromUserID, toUserID)
        .orElseThrow(() -> new ResourceNotFoundException("FriendRequest not found " + fromUserID + " " + toUserID));
        return FriendRequestMapper.mapToFriendRequestDto(friendRequest);
    }

    @Override
    public void deleteFriendRequest(Long requestId) {
        FriendRequest friendRequest = friendRequestRepository.findById(requestId)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + requestId));
        friendRequestRepository.delete(friendRequest);
    }
}

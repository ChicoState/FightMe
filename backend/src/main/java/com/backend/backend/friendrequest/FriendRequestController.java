package com.backend.backend.friendrequest;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;


@RestController
@RequestMapping("/api/friendrequests")
@AllArgsConstructor
// @CrossOrigin(origins = "http://localhost:60966")
@CrossOrigin(origins = "*")
public class FriendRequestController {
    private FriendRequestService friendRequestService;

    @PostMapping
    public ResponseEntity<FriendRequestDto> sendFriendRequest(@RequestBody FriendRequestDto friendRequestDto) {
        Long fromUserID = friendRequestDto.getFromUserID();
        Long toUserID = friendRequestDto.getToUserID();
        FriendRequestDto friendRequest = friendRequestService.sendFriendRequest(fromUserID, toUserID);
        return new ResponseEntity<>(friendRequest, HttpStatus.CREATED);
    }

    @PutMapping("accept")
    public ResponseEntity<FriendRequestDto> acceptFriendRequest(@RequestBody FriendRequestDto friendRequestDto) {
        Long friendRequestID = friendRequestDto.getId();
        FriendRequestDto friendRequest = friendRequestService.acceptFriendRequest(friendRequestID);
        return new ResponseEntity<>(friendRequest, HttpStatus.OK);
    }

    @PutMapping("reject")
    public ResponseEntity<FriendRequestDto> rejectFriendRequest(@RequestBody FriendRequestDto friendRequestDto) {
        Long friendRequestID = friendRequestDto.getId();
        FriendRequestDto friendRequest = friendRequestService.rejectFriendRequest(friendRequestID);
        return new ResponseEntity<>(friendRequest, HttpStatus.OK);
    }
    
    @GetMapping("{userID}")
    public ResponseEntity<List<FriendRequestDto>> getAllFriendRequestForUser(@PathVariable("userID") Long userID) {
        List<FriendRequestDto> friendRequests = friendRequestService.getAllFriendRequestForUser(userID);
        return new ResponseEntity<>(friendRequests, HttpStatus.OK);
    }

}

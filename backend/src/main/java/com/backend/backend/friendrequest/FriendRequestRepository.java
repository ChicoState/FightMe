package com.backend.backend.friendrequest;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.backend.backend.friendrequest.FriendRequest.Status;

import java.util.List;


@Repository
public interface FriendRequestRepository extends JpaRepository<FriendRequest, Long> {
    List<FriendRequest> findByFromUserID(Long fromUserID);
    List<FriendRequest> findByToUserID(Long toUserID);
    List<FriendRequest> findByFromUserIDAndToUserIDAndStatus(Long fromUserID, Long toUserID, Status rejected);
}

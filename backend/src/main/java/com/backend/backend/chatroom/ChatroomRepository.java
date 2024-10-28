package com.backend.backend.chatroom;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.backend.backend.user.User;

@Repository
public interface ChatroomRepository extends JpaRepository<Chatroom, Long> {
    List<Chatroom> findByUsers(User user);
}

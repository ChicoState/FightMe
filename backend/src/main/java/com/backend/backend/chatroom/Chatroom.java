package com.backend.backend.chatroom;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import com.backend.backend.message.Message;
import com.backend.backend.user.User;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "chatrooms")
public class Chatroom {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToMany
    @JoinTable(
        name = "chatroom_users", // Name of the join table
        joinColumns = @JoinColumn(name = "chatroom_id"), // Current entity's column
        inverseJoinColumns = @JoinColumn(name = "user_id") // Friend entity's column
    )
    private List<User> users;

    @OneToMany(mappedBy = "chatroomId", cascade = CascadeType.ALL)
    private List<Message> conversations;
}

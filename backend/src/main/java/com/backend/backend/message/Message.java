package com.backend.backend.message;

import com.backend.backend.chatroom.Chatroom;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "users")
public class Message {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @Column(name = "toId")
    private long toId;

    @Column(name = "fromId")
    private long fromId;

    @Column(name = "content")
    private String content;

    @Column(name = "isRead")
    private Boolean isRead;

    @Column(name = "timeStamp")
    private long timeStamp;

    @ManyToOne
    @JoinColumn(name = "chatroom_id")
    private Chatroom chatroom;
}

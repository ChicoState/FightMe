package com.backend.backend.friendrequest;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "friend_requests", uniqueConstraints = {@UniqueConstraint(columnNames = {"from_user_id", "to_user_id"})})
public class FriendRequest {

    public enum Status {
        PENDING,
        ACCEPTED,
        REJECTED
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "from_user_id", nullable = false)
    private Long fromUserID;

    @Column(name = "to_user_id", nullable = false)
    private Long toUserID;

    @Column(name = "status", nullable = false)
    @Enumerated(EnumType.STRING)
    private Status status;
}

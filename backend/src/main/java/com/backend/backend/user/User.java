package com.backend.backend.user;

import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name")
    private String name;

    @Column(name = "dateCreated")
    private long dateCreated;

    @Column(name = "gamerScore")
    private int gamerScore;

    // @ManyToMany
    // @JoinTable(
    //     name = "user_friends", // Name of the join table
    //     joinColumns = @JoinColumn(name = "user_id"), // Current entity's column
    //     inverseJoinColumns = @JoinColumn(name = "friend_id") // Friend entity's column
    // )
    // private List<User> friends;

    @ElementCollection
    @CollectionTable(name = "user_friends", joinColumns = @JoinColumn(name = "user_id"))
    @Column(name = "friend_id")
    private List<Long> friends; //storing just the id of the friends not the user

    @Column(name = "email", nullable = false, unique = true)
    private String email;

    @Column(name = "password")
    private String password;        //Should be hashed later

    // @ManyToMany(mappedBy = "users")
    // private List<Chatroom> chatrooms;

}

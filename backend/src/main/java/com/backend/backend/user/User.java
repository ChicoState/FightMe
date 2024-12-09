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
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Arrays;
import java.util.List;

import com.backend.backend.fightGame.FightGame;


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
    private Integer gamerScore;

    @Column(name = "attackScore")
    private Integer attackScore;

    @Column(name = "defenseScore")
    private Integer defenseScore;

    @Column(name = "magicScore")
    private Integer magicScore;

    @Column(name = "profilePicture")
    private Long profilePicture;

    @ElementCollection
    @CollectionTable(name = "user_unlocked_profile_pictures", joinColumns = @JoinColumn(name = "user_id"), uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "profile_picture_id"}))
    @Column(name = "profile_picture_id")
    private List<Long> unlockedProfilePictures;

    @Column(name = "theme")
    private Long theme;

    @ElementCollection
    @CollectionTable(name = "user_unlocked_themes", joinColumns = @JoinColumn(name = "user_id"), uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "theme_id"}))
    @Column(name = "theme_id")
    private List<Long> unlockedThemes;

    @ElementCollection
    @CollectionTable(name = "user_friends", joinColumns = @JoinColumn(name = "user_id"))
    @Column(name = "friend_id")
    private List<Long> friends; //storing just the id of the friends not the user

    @ManyToMany
    @JoinTable(
        name = "user_fight_game_sessions", // Name of the join table
        joinColumns = @JoinColumn(name = "user_id"), // Current entity's column
        inverseJoinColumns = @JoinColumn(name = "fight_game_id") // Friend entity's column
    )
    private List<FightGame> gameSessions;

    @Column(name = "email", nullable = false, unique = true)
    private String email;

    @Column(name = "password")
    private String password;        //Should be hashed later


    

    @PrePersist
    protected void onCreate() {
        this.dateCreated = System.currentTimeMillis();
        this.unlockedProfilePictures = Arrays.asList(Long.valueOf(0));
        this.unlockedThemes = Arrays.asList(Long.valueOf(0), Long.valueOf(1));
    }

}

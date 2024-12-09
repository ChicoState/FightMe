package com.backend.backend.fightGame;
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
import jakarta.persistence.MapKeyColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Arrays;
import java.util.Map;
import java.util.List;

import com.backend.backend.user.User;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "fight_games")
public class FightGame {

    public enum Move {
        ATTACK,
        DEFENSE,
        MAGIC,
        NONE
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Until someone wins: 0
    // If they draw: -1
    @Column(name = "winner_id")
    private Integer winnerID;

    @Column(name = "user_1")
    private User user1;

    @Column(name = "user_2")
    private User user2;

    // Starts at 5?
    @Column(name = "user_1_hp")
    private Integer user1HP;

    @Column(name = "user_2_hp")
    private Integer user2HP;

    @ElementCollection
    @MapKeyColumn(name="user_id")//key
    @Column(name="user_move") //value
    @CollectionTable(name="game_user_moves",
    joinColumns=@JoinColumn(name="game_id"))//fk from Areas->contacts.id
    private Map<Integer, List<Move>> moves;

    @PrePersist
    protected void onCreate() {
        this.winnerID = 0;
        this.user1HP = 5;
        this.user2HP = 5;
    }
}

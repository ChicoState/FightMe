package com.backend.backend.fightGame.Dto;

import com.backend.backend.fightGame.FightGame.Move;
import com.backend.backend.user.User;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.util.Map;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class FightGameDto {
    private long id;
    private Integer winnerID;
    private User user1;
    private User user2;
    private Integer user1HP;
    private Integer user2HP;
    private Map<Integer, List<Move>> moves;
}

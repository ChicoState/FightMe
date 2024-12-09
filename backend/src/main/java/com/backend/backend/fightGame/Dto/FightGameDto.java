package com.backend.backend.fightGame.Dto;

import com.backend.backend.fightGame.FightGame.Move;
import com.backend.backend.user.Dto.UserDto;

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
    private Long id;
    private Integer winnerID;
    private Long requesterID;
    private UserDto user1;
    private UserDto user2;
    private Integer user1HP;
    private Integer user2HP;
    private Map<Long, List<Move>> moves;
}

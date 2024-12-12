package com.backend.backend.fightGame.Dto;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.backend.backend.fightGame.FightGame.Move;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserMoveDto {
    private Long userID;
    Move move;
}

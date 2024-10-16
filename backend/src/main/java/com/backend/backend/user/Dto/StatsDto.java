package com.backend.backend.user.Dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class StatsDto {
    private int attackScore;
    private int defenseScore;
    private int magicScore;
}

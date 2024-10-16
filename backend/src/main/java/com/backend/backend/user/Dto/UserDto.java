package com.backend.backend.user.Dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserDto {

    private Long id;
    private String name;
    private long dateCreated;
    private int gamerScore;
    private int attackScore;
    private int defenseScore;
    private int magicScore;
    private List<Long> friends; //changed to list long
    private String email;
    private String password;
    
}

package com.backend.backend.user;

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
    private List<User> friends;
    private String email;
    private String password;
    
}

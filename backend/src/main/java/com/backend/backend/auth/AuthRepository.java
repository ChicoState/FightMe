package com.backend.backend.auth;

import org.springframework.stereotype.Repository;
import com.backend.backend.user.UserRepository;
import lombok.AllArgsConstructor;

@Repository
@AllArgsConstructor
public class AuthRepository{

    private UserRepository userRepository;

    public boolean findByEmail(String email){                                       //checks the user repository to see if the email exists
        return userRepository.findByEmail(email).isPresent();
    }

    public boolean authenticate(String email, String password){                     //checks the user repository to see if the password is correct
        return userRepository.findByEmailAndPassword(email, password).isPresent();
    }
}

package com.backend.backend.auth;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.backend.backend.ResourceNotFoundException;
import com.backend.backend.user.User;
import com.backend.backend.user.UserMapper;
import com.backend.backend.user.UserRepository;
import com.backend.backend.user.Dto.UserDto;
import lombok.AllArgsConstructor;

@RestController
@RequestMapping("/api/")
@AllArgsConstructor
// @CrossOrigin(origins = "http://localhost:60966") 
@CrossOrigin(origins = "*")
public class AuthController {
    private UserRepository userRepository;
    private AuthRepository authRepository;

    // Registers a new user, and creates it in the database
    @PostMapping("signup")
    public ResponseEntity<?> registerUser(@RequestBody UserDto userDto){                                 //Can be refactored
        if (userDto.getPassword() == null || userDto.getPassword().length() < 8) {                      //Checks if the password is there and is at least 8 characters long 
            return ResponseEntity.badRequest().body("Password must be at least 8 characters long");
        }

        User user = UserMapper.mapToUser(userDto);
        if(authRepository.findByEmail(user.getEmail())){                                                //Checks if the email already exists
            return ResponseEntity.badRequest().body("Email already exists");
        }
        if(user.getName() == null){
            return ResponseEntity.badRequest().body("Name cannot be empty");                        //Checks if the name is there
        }
        userRepository.save(user);                                                                        //Saves the user to the database  
        User savedUser = userRepository.findByEmail(userDto.getEmail()).orElseThrow(() -> new ResourceNotFoundException("User not found: " + userDto.getEmail()));
        long savedId = savedUser.getId();
        return new ResponseEntity<>(savedId, HttpStatus.CREATED);                                         //Returns the user id
    }


    // Logs in the user
    @PostMapping("login")
    public ResponseEntity<?> loginUser(@RequestBody UserDto userDto){               //Can be refactored
        User user = UserMapper.mapToUser(userDto);
        if(!authRepository.findByEmail(user.getEmail())){                           //Checks if the email exists
            return ResponseEntity.badRequest().body("Email does not exist");
        }
        if(!authRepository.authenticate(user.getEmail(), user.getPassword())){      //Checks if the password is correct
            return ResponseEntity.badRequest().body("Password does not match");
        }
        User savedUser = userRepository.findByEmail(userDto.getEmail()).orElseThrow(() -> new ResourceNotFoundException("User not found: " + userDto.getEmail()));
        long savedId = savedUser.getId();
        return new ResponseEntity<>(savedId, HttpStatus.OK);      //Returns the user id
    }
}

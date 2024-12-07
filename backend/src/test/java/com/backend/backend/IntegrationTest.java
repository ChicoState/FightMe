package com.backend.backend;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
public class IntegrationTest {

    @Autowired
    private MockMvc mockMVC;

    @Test 
    void SignUpTestUser() throws Exception {
        String signUpJson = "{\"name\":\"TestUser\", \"email\":\"test@test.com\", \"password\":\"123456\"}";
        mockMVC.perform(post("/api/users")
                .contentType("application/json")
                .content(signUpJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.name").value("TestUser"))
                .andExpect(jsonPath("$.email").value("test@test.com"))
                .andExpect(jsonPath("$.password").value("123456"))
                .andExpect(jsonPath("$.gamerScore").value(0))
                .andExpect(jsonPath("$.attackScore").value(0))
                .andExpect(jsonPath("$.defenseScore").value(0))
                .andExpect(jsonPath("$.magicScore").value(0))
                .andExpect(jsonPath("$.friends").isEmpty());
    }

    @Test
    void SignUpTestUser2() throws Exception {
        String signUpJson = "{\"name\":\"TestUser2\", \"email\":\"test2@test.com\", \"password\":\"123456\"}";
        mockMVC.perform(post("/api/users")
                .contentType("application/json")
                .content(signUpJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").value(2))
                .andExpect(jsonPath("$.name").value("TestUser2"))
                .andExpect(jsonPath("$.email").value("test2@test.com"))
                .andExpect(jsonPath("$.password").value("123456"))
                .andExpect(jsonPath("$.gamerScore").value(0))
                .andExpect(jsonPath("$.attackScore").value(0))
                .andExpect(jsonPath("$.defenseScore").value(0))
                .andExpect(jsonPath("$.magicScore").value(0))
                .andExpect(jsonPath("$.friends").isEmpty())
                ;
    }

    @Test
    void SignUpTestUser3() throws Exception {
        String signUpJson = "{\"name\":\"TestUser3\", \"email\":\"test3@test.com\", \"password\":\"123456\"}";
        mockMVC.perform(post("/api/users")
                .contentType("application/json")
                .content(signUpJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").value(3))
                .andExpect(jsonPath("$.name").value("TestUser3"))
                .andExpect(jsonPath("$.email").value("test3@test.com"))
                .andExpect(jsonPath("$.password").value("123456"))
                .andExpect(jsonPath("$.gamerScore").value(0))
                .andExpect(jsonPath("$.attackScore").value(0))
                .andExpect(jsonPath("$.defenseScore").value(0))
                .andExpect(jsonPath("$.magicScore").value(0))
                .andExpect(jsonPath("$.friends").isEmpty())
                ;
    }

    @Test
    void LoginTestUser() throws Exception {
        String loginJson = "{\"email\":\"test@test.com\", \"password\":\"123456\"}";
        mockMVC.perform(post("/api/login")
                .contentType("application/json")
                .content(loginJson))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1));
    }


    @Test
    void TestGetUser() throws Exception {
        mockMVC.perform(get("/api/users/1")
                .contentType("application/json"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.name").value("Test User"))
                .andExpect(jsonPath("$.email").value("test@test.com"))
                .andExpect(jsonPath("$.password").value("123456"));
    }

    @Test
    void SendUser1FriendRequestToUser2() throws Exception {
        String sendFriendRequestJson = "{\"fromUserID\":1, \"toUserID\":2}";
        mockMVC.perform(post("/api/friendRequests")
                .contentType("application/json")
                .content(sendFriendRequestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.fromUserID").value(1))
                .andExpect(jsonPath("$.toUserID").value(2))
                .andExpect(jsonPath("$.Status").value("PENDING"));
    }

    @Test
    void RejectUser1FriendRequestToUser2() throws Exception {
        String rejectFriendRequestJson = "{\"id\":1}";
        mockMVC.perform(put("/api/friendRequests/reject")
                .contentType("application/json")
                .content(rejectFriendRequestJson))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.fromUserID").value(1))
                .andExpect(jsonPath("$.toUserID").value(2))
                .andExpect(jsonPath("$.Status").value("REJECTED"));
    }

    @Test
    void SendUser2FriendRequestToUser1() throws Exception {
        String sendFriendRequestJson = "{\"fromUserID\":2, \"toUserID\":1}";
        mockMVC.perform(post("/api/friendRequests")
                .contentType("application/json")
                .content(sendFriendRequestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").value(2))
                .andExpect(jsonPath("$.fromUserID").value(2))
                .andExpect(jsonPath("$.toUserID").value(1))
                .andExpect(jsonPath("$.Status").value("PENDING"));
    }

    @Test
    void AcceptUser2FriendRequestToUser1() throws Exception {
        String acceptFriendRequestJson = "{\"id\":2}";
        mockMVC.perform(put("/api/friendRequests/accept")
                .contentType("application/json")
                .content(acceptFriendRequestJson))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(2))
                .andExpect(jsonPath("$.fromUserID").value(2))
                .andExpect(jsonPath("$.toUserID").value(1))
                .andExpect(jsonPath("$.Status").value("ACCEPTED"));
    }

    @Test
    void GetUser1Friends() throws Exception {
        mockMVC.perform(get("/api/users/1/friends")
                .contentType("application/json"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0]").value(2));
    }

    @Test
    void GetUser2Friends() throws Exception {
        mockMVC.perform(get("/api/users/2/friends")
                .contentType("application/json"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0]").value(1));
    }

    @Test
    void GetUser1SuggestedFriends() throws Exception {
        mockMVC.perform(get("/api/users/1/suggestedFriends")
                .contentType("application/json"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].id").value(3))
                .andExpect(jsonPath("$[0].name").value("TestUser3"))
                .andExpect(jsonPath("$[0].email").value("test3@test.com"))
                .andExpect(jsonPath("$[0].password").value("123456"));
    }

    @Test
    void GetUser2SuggestedFriends() throws Exception {
        mockMVC.perform(get("/api/users/2/suggestedFriends")
                .contentType("application/json"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].id").value(3))
                .andExpect(jsonPath("$[0].name").value("TestUser3"))
                .andExpect(jsonPath("$[0].email").value("test3@test.com"))
                .andExpect(jsonPath("$[0].password").value("123456"));
    }
    
    @Test
    void GetUser3SuggestedFriends() throws Exception {
        mockMVC.perform(get("/api/users/3/suggestedFriends")
                .contentType("application/json"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].id").value(1))
                .andExpect(jsonPath("$[0].name").value("TestUser"))
                .andExpect(jsonPath("$[0].email").value("test@test.com"))
                .andExpect(jsonPath("$[0].password").value("123456"))
                .andExpect(jsonPath("$[1].id").value(2))
                .andExpect(jsonPath("$[1].name").value("TestUser2"))
                .andExpect(jsonPath("$[1].email").value("test2@test.com"))
                .andExpect(jsonPath("$[1].password").value("123456"));
    }

}

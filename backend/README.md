

# Backend/API Guide

## Table of Contents
1. [Backend Setup](#to-get-everything-setup)
2. [User API](#user-endpoints)
3. [Chatroom API](#chatroom-endpoints)
4. [Message API](#message-endpoints)
5. [Friend Request API](#friend-request-endpoints)
6. [Authentication API](#authentication-endpoints)

## To Get Everything Setup

1. Clone this repository to your computer.
2. With VScode, under the extensions tab, install SpringBoot Extension Pack and Java Extension Pack.
3. Install [PostgreSQL](https://www.postgresql.org/download/) 15.8 or higher. 
    * For ease of use, I recommend keeping the username to postgres and setting the password to abc123.
    * Keep the port to 5432.
    * Keep cluseter local 
    * Launch PostgreSQL. Under Servers / PostgreSQL, right click on **Databases** , click **Create** and click **Database...** and set the name to **UserDB**. Keep everything else as default.
    * For later on, If you want to view the database, go to Servers / PostgreSQL / Databases / UserDB / Schemas / Public / Tables and you should see all your tables. From there, you can right click on one of your tables and click **View/Delete Data** then **All Rows** and then you should see your stuff. You can also refresh as well but you can find that.
4. Install [Postman](https://www.postman.com/downloads/)
    * You can use Postman to test your API endpoints.
    * For POST, make sure to select body / raw / JSON ~~instead of Text~~. No need for name: "Joel" for now.
    ![Picture cred](https://media2.dev.to/dynamic/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fassets.apidog.com%2Fblog%2F2024%2F03%2Fimage-61.png)

## To Run the Backend in VSCode

1. Just click on one of the folders (i just use the BackendApplication.java file)
2. Click the run button on the top right corner of the file.
3. You should have a giant SPRING logo in the terminal in the beginning and it should be running. At the bottom of the terminal, you should see the port it is running on.
    * Like so _2024-10-04T00:43:04.697-07:00  INFO 59413 --- [backend] [  restartedMain] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port 8080 (http) with context path '/'
2024-10-04T00:43:04.710-07:00  INFO 59413 --- [backend] [  restartedMain] com.backend.backend.BackendApplication   : Started BackendApplication in 4.986 seconds (process running for 5.612)_

- Alternatively you can use CLI to start it up but its simpler to just click some buttons but you'd have to do something along the lines of (could work, could not as well. I don't know just use the other method)
  ```
		mvn spring-boot:run
  ```

# API Documentation

The RESTful APIs are designed to feed information to and from the frontend to the backend. Very simple APIs.

## User Endpoints
The User contains information such as username, gmail, password, but also includes gamerscore, stats, and friends.
1. [Get Endpoints](#get-endpoints)
2. [Post Endpoints](#post-endpoints)
3. [Put Endpoints](#put-endpoints)
4. [Delete Endpoints](#delete-endpoints)
---
### Get Endpoints
#### Getting User Information by their UserID
- http://localhost:8080/api/users/{userID}
- Your response should be a 200 OK with a JSON similar to this
```
	{
			"id": 1,
            "name": "Him",
            "dateCreated": 0,
            "gamerScore": 9000,
            "attackScore": 1,
            "defenseScore": 2,
            "magicScore": 3,
            "friends": [
	            1,
	            2,
	            3
			],
            "email": "him@mail.com",
            "password": "password"
    }
```
#### Getting All Users in the Database
- http://localhost:8080/api/users
- Your response should be a 200 OK with a JSON similar to this
```
	[
		{
				"id": 1,
	            "name": "Him",
	            "dateCreated": 0,
	            "gamerScore": 9000,
	            "attackScore": 1,
	            "defenseScore": 2,
	            "magicScore": 3,
	            "friends": [
		            1,
		            2,
		            3
				],
	            "email": "him@mail.com",
	            "password": "password"
	        },
	        {
				"id": 2,
	            "name": "Her",
	            "dateCreated": 0,
	            "gamerScore": 9000,
	            "attackScore": 1,
	            "defenseScore": 2,
	            "magicScore": 3,
	            "friends": [
		            3,
		            4,
		            5
				],
	            "email": "her@mail.com",
	            "password": "password"
	        }
	]
```
#### Getting a User's Friends List
- http://localhost:8080/api/users/{userID}/friends
- Your response should be a 200 OK with a JSON similar to 
```
	[
		1,
		2,
		3
	]
```
#### Getting a User's Suggested Friends
- http://localhost:8080/api/users/{userID}/suggestedFriends
- Your response should be a 200 OK with a JSON similar to 
```
	[
		{
				"id": 4,
	            "name": "Jimmy",
	            "dateCreated": 0,
	            "gamerScore": 9000,
	            "attackScore": 1,
	            "defenseScore": 2,
	            "magicScore": 3,
	            "friends": [],
	            "email": "fdas@mail.com",
	            "password": "fdafdasfdasfdsa"
	        },
	        {
				"id": 5,
	            "name": "yessir",
	            "dateCreated": 0,
	            "gamerScore": 9000,
	            "attackScore": 1,
	            "defenseScore": 2,
	            "magicScore": 3,
	            "friends": [
		            2,
		            3
				],
	            "email": "yessiirrrr@mail.com",
	            "password": "noossiiirrr"
	        }
	]
```
---
### Post Endpoints
#### Creating a New User
- http://localhost:8080/api/users
- Your body should be formatted as such (Could include more information such as stats,friends, etc...)
```
	{
            "name": "Him",
            "email": "him@mail.com",
            "password": "password"
    }
```
- Your response should be a 201 CREATED with a JSON similar to 
```
	{
				"id": 1,
	            "name": "Him",
	            "dateCreated": 0,
	            "gamerScore": 0,
	            "attackScore": 0,
	            "defenseScore": 0,
	            "magicScore": 0,
	            "friends": null,
	            "email": "him@mail.com",
	            "password": "password"
	 }
```
---
### Put Endpoints
#### Update a User's GamerScore
- http://localhost:8080/api/users/{userID}/gamerScore
- Your body should include the newly updated gamerScore you want to update with
```
	{
		"gamerScore": 100
	}
```
- Your response should be a 200 OK with a JSON similar to 
```
	{
				"id": 1,
	            "name": "Him",
	            "dateCreated": 0,
	            "gamerScore": 100,
	            "attackScore": 0,
	            "defenseScore": 0,
	            "magicScore": 0,
	            "friends": null,
	            "email": "him@mail.com",
                "password": "password"
	}
```
#### Update a User's Stats
- http://localhost:8080/api/users/{userID}/stats
- Your body should include each of the stats; attackScore, magicScore, defenseScore
```
	{
         "attackScore": 10,
         "defenseScore": 10,
         "magicScore": 10
	}
```
- Your response should be a 200 OK with a JSON of 
```
	{
				"id": 1,
	            "name": "Him",
	            "dateCreated": 0,
	            "gamerScore": 100,
	            "attackScore": 10,
	            "defenseScore": 10,
	            "magicScore": 10,
	            "friends": null,
	            "email": "him@mail.com",
                "password": "password"
	}
```
#### Update a User's Friends
- http://localhost:8080/api/users/{userID}/friends
- Your body should include the friendID as so
```
	{
		"friendId": 2
	}
```
- Your response should be a 200 OK with a JSON 
```
	{
                "id": 1,
	            "name": "Him",
	            "dateCreated": 0,
	            "gamerScore": 100,
	            "attackScore": 10,
	            "defenseScore": 10,
	            "magicScore": 10,
	            "friends": [
		            2
	            ],
	            "email": "him@mail.com",
                "password": "password"
	}
```
---
### Delete Endpoints 
#### Delete a User 
- http://localhost:8080/api/users/{userID}
- Your response should be a 200 OK with a body of a string returning 
```
	User Deleted
```
### Delete a User's Friend
- http://localhost:8080/api/users/{userID}/friends
- Your response should be a 200 OK with a body of a string returning 
```
	Friend Deleted
```
---
## Chatroom Endpoints
## Message Endpoints
## Friend Request Endpoints
## Authentication Endpoints




















1. Create 2 new Users
    * Heres an example of the JSON body for the POST request:
    With the URL being: http://localhost:8080/api/users on POST
        ```
        {
            "name": "Him",
            "dateCreated": 0,
            "gamerScore": 9000,
            "friends": [],
            "email": "him@mail.com",
            "password": "password"
        }
        ```
2. Create a chatroom with the 2 users you just created with no conversations.
    * This is the better and improved version of how to create a chatroom with user 1 and 2. You should be returned the same as the previous example.
    * Be sure to use http://localhost:8080/api/chatroom/create on POST
        ```
        {
            "userIds": [1,2]
        }
        ```
    * ~~Heres an example of the JSON body for the POST request:
    With the URL being: http://localhost:8080/api/chatroom/1 on POST~~
    * This is the depricated version
        ```
        {
        "users": [
            {
                "id": 1,
                "name": "Him",
                "dateCreated": 0,
                "gamerScore": 9000,
                "friends": [],
                "email": "him@mail.com",
                "password": "password"
            },
            {
                "id": 2,
                "name": "Her",
                "dateCreated": 0,
                "gamerScore": 420,
                "friends": [],
                "email": "her@mail.com",
                "password": "abc123"
            }
        ],
        "conversations": []
        }
        ```
3. If you want to delete a chatroom, you can! It will delete all the messages and conversations in the chatroom. Just be sure to know the chatroom id.
    * If you want to delete the chatroom with id:1, use http://localhost:8080/api/chatroom/1 on DELETE
4. If you want to see all the chatrooms that a user is in, you can use the following endpoint:
    * If you want to see all the chatrooms that user 1 is in, use http://localhost:8080/api/chatroom/user/1 on GET
    * You will be returned a list of chatrooms.
    * Heres an example of the JSON body when you request user 1's chatrooms with them having chatrooms with user 2 and 3:
        ```
        [
            {
                "id": 3,
                "users": [
                    {
                        "id": 1,
                        "name": "Him",
                        "dateCreated": 0,
                        "gamerScore": 60,
                        "attackScore": 1000,
                        "defenseScore": 10,
                        "magicScore": 5,
                        "friends": [
                            2,
                            4,
                            3
                        ],
                        "email": "him@mail.com",
                        "password": "password"
                    },
                    {
                        "id": 2,
                        "name": "Her",
                        "dateCreated": 0,
                        "gamerScore": 420,
                        "attackScore": 5,
                        "defenseScore": 20,
                        "magicScore": 1,
                        "friends": [
                            1,
                            3
                        ],
                        "email": "her@mail.com",
                        "password": "abc123"
                    }
                ],
                "conversations": []
            },
            {
                "id": 4,
                "users": [
                    {
                        "id": 1,
                        "name": "Him",
                        "dateCreated": 0,
                        "gamerScore": 60,
                        "attackScore": 1000,
                        "defenseScore": 10,
                        "magicScore": 5,
                        "friends": [
                            2,
                            4,
                            3
                        ],
                        "email": "him@mail.com",
                        "password": "password"
                    },
                    {
                        "id": 3,
                        "name": "John",
                        "dateCreated": 0,
                        "gamerScore": 999,
                        "attackScore": 0,
                        "defenseScore": 0,
                        "magicScore": 0,
                        "friends": [
                            2,
                            1
                        ],
                        "email": "john@mail.com",
                        "password": "johnspassword"
                    }
                ],
                "conversations": []
            }
        ]
        ```
3. Create a message with the chatroom id you just created with no conversations.
    * Heres an example of the JSON body for the POST request:
    With the URL being: http://localhost:8080/api/messages/1 on POST
        ```
        {
            "toId": 1,
            "fromId": 2,
            "content": "Second message to Chatroom 1",
            "chatroomId": 1
        }
        ```
4. With this, you can use the GET endpoints to see the data you just created. If you want to get all, usually its without the _/1_ at the end of the url. But if you want something more specific, you can add the id at the end.
    * Heres an example of the GET request:
    With the URL being: http://localhost:8080/api/users/1 on GET
        ```
        {
            "id": 1,
            "name": "Him",
            "dateCreated": 0,
            "gamerScore": 9000,
            "friends": [],
            "email": "him@mail.com",
            "password": "password"
        }
        ```
5. Currently you can only update (PUT) your GamerScore and your friends.
    * Heres an example of updating your gamerscore for user 1 to 100:
      With URL being: http://localhost:8080/api/users/1/gamerScore on PUT
      ```
       {
           "gamerScore": 100
       }
       ```
   * Heres an exmaple of adding User2 for User1 (*Update: wont need with frriend request):
     With the URL being: http://localhost:8080/api/users/1/friends on PUT
     ```
     {
       "friendId": 3
     }
     ```
6. We only have functionality of deleting friends for now. The url follows api/users/{id of user you want to change}/friends.
    * Heres an example of deleting friend 3 as User 1:
      With the URL being: http://localhost:8080/api/users/1/friends on DELETE
        ```
         {
           "friendId": 3
         }
         ```
7. If you want to add a friend, first send a friend request! To do so, get the user's id and your id! IT WILL 404 if you're already friends with each other or if they cant find the users.
    * Heres how to send a friend request to User 2 from User 1: 
    With the URL being: http://localhost:8080/api/friendrequests on POST
        ```
        {
            "fromUserID": 2,
            "toUserID": 1
        }
        ```
8. Now if you want to accept/reject this friend request, get the friend request id! 
    * Heres how to accept/reject friend request id 1: 
    With the URL being http://localhost:8080/api/friendrequests/accept on PUT
    Or 
    With the URL being http://localhost:8080/api/friendrequests/reject on PUT
        ```
        {
            "id": 1
        }
        ```
    * After accepting, you can do a get on either user and see that they are now friends!
    * If rejected, then neither of the users will have each other on the friends list :(
11. If you want to level up or level down your attributes, you can do so with the following endpoints:
    * Heres an example of leveling up your stats for id 1: 
    With the URL being: http://localhost:8080/api/users/1/stats on PUT
        ```
        {
            "attackScore": 10,
            "defenseScore": 2,
            "magicScore": 31
        }
        ```
    * BTW be sure to update your stats to 0 if you have an existing user with no stats. Like when you try to getUserById(1) and you didnt update stats, stats will be null in the database. So to alleviate this, you can just update your stats to 0.

## User Authentication 
Currently the user authentication is done using a very simple REST API. It is not secure at all and passwords are not hashed. But it is a good start and a okay MVP.

Not everything is finalized yet, can be changed later.

### To Signup
---
* Make a POST request to http://localhost:8080/api/signup with the following body:
    ```
    {
        "name": "Him",
        "email": "him@mail.com",
        "password": "password"
    }
    ```
    * This will create a new user with the name Him, email him@mail.com, and password password. The rest of the values are going to be their default values except the dateCreated which will be the current time it got created.
    * If the email already exists, it will return a 400 Bad Request with the message "Email already exists".
    * If the name is null, it will return a 400 Bad Request with the message "Name cannot be empty".
    * If the password is null or less than 8 characters long, it will return a 400 Bad Request with the message "Password must be at least 8 characters long".
    * If everything is okay, it will return a 200 OK with the user's id.

### To Login
---
* Make a POST request to http://localhost:8080/api/login with the following body:
    ```
    {
        "email": "him@mail.com",
        "password": "password"
    }
    ```
    * This will login the user with the email him@mail.com and password password. If the email does not exist, it will return a 400 Bad Request with the message "Email does not exist".
    * If the password does not match, it will return a 400 Bad Request with the message "Password does not match".
    * If everything is okay, it will return a 200 OK with the user's id.
## To Get this working with Flutter

1. Open PostgresSQL 
2. Run the Spring Boot Application
3. Run Flutter in command line
   * Use this command to save some time:  _flutter run -d chrome --web-port="60966"_

# Sprint 2 Goals For Backend


- ~~User Authentication (JWT ???)~~
- Update/Delete requests for User/Messages/Chatroom
- ~~Be able to update gamerscore~~
- ~~Add attack, defense, magic attributes to user~~
- Update read reciepts
- ~~Implement Friends Feature (Creating friendRequest class)~~

# Sprint 3 Goals for Backend

- Game Entity to store game information
- Websockets for the game? 

# Long Term Goals

- Add websockets for real time communications
- Be able to send and recieve pictures
    - Store images somehow for chatrooms
- CI/CD with good unit testing
- Containerize using docker and docker compose








Written and Setup by Taiga. 

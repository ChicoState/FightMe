


# Backend/API Guide

## Table of Contents
-   [Backend Setup](#to-get-everything-setup)
-   [Run the Backend in VSCode](#to-run-the-backend-in-vscode)
-   [Run With Flutter](#to-get-this-working-with-flutter)
-   [User API](#user-endpoints)
    -   [Get User Endpoints](#get-user-endpoints)
        -   [Get User by ID](#getting-user-information-by-their-user-id)
        -   [Get All Users](#getting-all-users-in-the-database)
        -   [Get User's Friends](#getting-a-users-friends-list)
        -   [Get Suggested Friends](#getting-a-users-suggested-friends)
    -   [Post User Endpoints](#post-user-endpoints)
        -   [Create New User](#creating-a-new-user)
    -   [Put User Endpoints](#put-user-endpoints)
        -   [Update GamerScore](#update-a-users-gamerscore)
        -   [Update Stats](#update-a-users-stats)
        -   [Update Friends](#update-a-users-friends)
    -   [Delete User Endpoints](#delete-user-endpoints)
        -   [Delete User](#delete-a-user)
        -   [Delete Friend](#delete-a-users-friend)
-   [Chatroom API](#chatroom-endpoints)
    -   [Get Chatroom Endpoints](#get-chatroom-endpoints)
        -   [Get Chatroom by ID](#getting-a-chatroom-by-the-chatroom-id)
        -   [Get User's Chatrooms](#getting-all-chatrooms-of-a-user)
        -   [Get All Chatrooms](#getting-all-chatrooms)
    -   [Post Chatroom Endpoints](#post-chatroom-endpoints)
        -   [Create Chatroom](#create-a-chatroom-with-user-ids)
    -   [Delete Chatroom Endpoints](#delete-chatroom-endpoints)
        -   [Delete Chatroom](#delete-a-chatroom-with-chatroom-id)
-   [Message API](#message-endpoints)
    -   [Get Message Endpoints](#get-message-endpoints)
        -   [Get Chatroom Messages](#get-all-messages-using-chatroom-id)
    -   [Post Message Endpoints](#post-message-endpoints)
        -   [Create Message](#post-message-endpoints)
-   [Friend Request API](#friend-request-endpoints)
    -   [Get Friend Request Endpoints](#get-friend-request-endpoints)
        -   [Get User's Friend Requests](#get-all-friend-requests-for-a-user)
    -   [Post Friend Request Endpoints](#post-friend-request-endpoints)
        -   [Send Friend Request](#send-a-friend-request-to-a-user)
    -   [Put Friend Request Endpoints](#put-friend-request-endpoints)
        -   [Accept Friend Request](#accept-a-friend-request)
        -   [Reject Friend Request](#reject-a-friend-request)
-   [Authentication API](#authentication-endpoints)
    -   [Post Authentication Endpoints](#post-authentication-endpoints)
        -   [Signup](#signup)
        -   [Login](#login)
-   [Sprint Goals](#sprint-2-goals-for-backend)
    -   [Sprint 2 Goals](#sprint-2-goals-for-backend)
    -   [Sprint 3 Goals](#sprint-3-goals-for-backend)
    -   [Long Term Goals](#long-term-goals)

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
## To Get this working with Flutter

1. Open PostgresSQL and login to the database
2. Run the Spring Boot Application
3. Run Flutter in command line
   * Use this command to save some time:  _flutter run -d chrome --web-port="60966"_

# API Documentation

The RESTful APIs are designed to feed information to and from the frontend to the backend. Very simple APIs.

## User Endpoints
The User contains information such as username, gmail, password, but also includes gamerscore, stats, and friends.
1. [Get Endpoints](#get-user-endpoints)
2. [Post Endpoints](#post-user-endpoints)
3. [Put Endpoints](#put-user-endpoints)
4. [Delete Endpoints](#delete-user-endpoints)
---
### Get User Endpoints
#### Getting User Information by their User ID
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
### Post User Endpoints
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
### Put User Endpoints
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
### Delete User Endpoints 
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
Chatroom contains information on the Users in the chatroom and the messages contained in them. 
1. [Get Endpoints](#get-chatroom-endpoints)
2. [Post Endpoints](#post-chatroom-endpoints)
3. [Delete Endpoints](#delete-chatroom-endpoints)
---
### Get Chatroom Endpoints
#### Getting a Chatroom by the Chatroom ID
- http://localhost:8080/api/chatroom/{chatroomID}
- Your response should be a 200 OK with a JSON 
```
	{
		"id": 1,
		"users": [
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
		],
		"conversations": [
			{
				"id": 1,
				"toId": 2,
				"fromId": 1,
				"content": "Hello",
				"timeStamp": 1232153,
				"chatroomId": 1
			},
			{
				"id": 2,
				"toId": 1,
				"fromId": 2,
				"content": "Hello",
				"timeStamp": 1232154,
				"chatroomId": 1
			}
		]
	}
```
---
#### Getting All Chatrooms of a User
- http://localhost:8080/api/chatroom/user/{userID}
- Your response should be a 200 OK with a JSON 
```
	[
		{
		"id": 1,
		"users": [
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
		],
		"conversations": [
			{
				"id": 1,
				"toId": 2,
				"fromId": 1,
				"content": "Hello",
				"timeStamp": 1232153,
				"chatroomId": 1
			},
			{
				"id": 2,
				"toId": 1,
				"fromId": 2,
				"content": "Hello",
				"timeStamp": 1232154,
				"chatroomId": 1
			}
		]
	}, 
	{
		"id": 2,
		"users": [
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
				"id": 3,
	            "name": "yo",
	            "dateCreated": 0,
	            "gamerScore": 0,
	            "attackScore": 10,
	            "defenseScore": 42,
	            "magicScore": 33,
	            "friends": [
		            1
				],
	            "email": "yo@mail.com",
	            "password": "password"
	        }
		],
		"conversations": [
			{
				"id": 3,
				"toId": 3,
				"fromId": 1,
				"content": "Hello",
				"timeStamp": 1232153,
				"chatroomId": 2
			},
			{
				"id": 4,
				"toId": 1,
				"fromId": 3,
				"content": "Hello",
				"timeStamp": 1232154,
				"chatroomId": 2
			}
		]
	}
]
```
---
#### Getting All Chatrooms
- http://localhost:8080/api/chatroom
- Your response should be a 200 OK with JSON 
```
	[
		{
		"id": 1,
		"users": [
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
		],
		"conversations": [
			{
				"id": 1,
				"toId": 2,
				"fromId": 1,
				"content": "Hello",
				"timeStamp": 1232153,
				"chatroomId": 1
			},
			{
				"id": 2,
				"toId": 1,
				"fromId": 2,
				"content": "Hello",
				"timeStamp": 1232154,
				"chatroomId": 1
			}
		]
	}, 
	{
		"id": 2,
		"users": [
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
				"id": 3,
	            "name": "yo",
	            "dateCreated": 0,
	            "gamerScore": 0,
	            "attackScore": 10,
	            "defenseScore": 42,
	            "magicScore": 33,
	            "friends": [
		            1
				],
	            "email": "yo@mail.com",
	            "password": "password"
	        }
		],
		"conversations": [
			{
				"id": 3,
				"toId": 3,
				"fromId": 1,
				"content": "Hello",
				"timeStamp": 1232153,
				"chatroomId": 2
			},
			{
				"id": 4,
				"toId": 1,
				"fromId": 3,
				"content": "Hello",
				"timeStamp": 1232154,
				"chatroomId": 2
			}
		]
	}
]
```
---
### Post Chatroom Endpoints
#### Create a Chatroom with User IDs
- http://localhost:8080/api/chatroom/create
- Your body should include a list of User IDs
```
	[1,2]
```
- Your response should be a 201 CREATED with a JSON returning 
```
	{
		"id": 1,
		"users": [
			{
				"id": 1,
	            "name": "Him",
	            "dateCreated": 0,
	            "gamerScore": 9000,
	            "attackScore": 1,
	            "defenseScore": 2,
	            "magicScore": 3,
	            "friends": [
		            2,
		            3,
		            4
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
		            1
				],
	            "email": "her@mail.com",
	            "password": "password"
	        }
		],
		"conversations": []
	}
```
--- 
### Delete Chatroom Endpoints
#### Delete a Chatroom with Chatroom ID
- http://localhost:8080/api/chatroom/{chatroomID}
- Your response should be a 200 OK if deleted
---
## Message Endpoints
The Message contains information about the user you're sending the message to and the user who sent the message, the content of the message, if the message is read, timestamp of the message, and what chatroom it belongs to.
1. [Get Endpoints](#get-message-endpoints)
2. [Post Endpoints](#post-message-endpoints)

---
### Get Message Endpoints
#### Get All Messages using Chatroom ID
- http://localhost:8080/api/messages/{chatroomID}
- Your response should be a 200 OK with a JSON containing a list of Messages
```
[
	{
		"id": 1,
		"toId": 2,
		"fromId": 1,
		"content": "Hello",
		"timeStamp": 1232153,
		"chatroomId": 1
	},
	{
		"id": 2,
		"toId": 1,
		"fromId": 2,
		"content": "Hello",
		"timeStamp": 1232154,
		"chatroomId": 1
	}
]
```
---
### Post Message Endpoints
- http://localhost:8080/api/messages
- Your body should include the userID who is sending and recieving the message, the content of the message, a boolean of if it is read or not, timestamp, and a chatroomID in which the message belongs to
```
{
	"toId": 1,
	"fromId": 2,
	"content": "Yo",
	"isRead": false,
	"timeStamp": 0,
	"chatroomId": 1
}
```
- Your response should be a 201 CREATED with a JSON containing the same message
 ```
{
	"toId": 1,
	"fromId": 2,
	"content": "Yo",
	"isRead": false,
	"timeStamp": 0,
	"chatroomId": 1
}
```
---
## Friend Request Endpoints
The Friend Request contains information about information on whether it is either pending, accepted, or rejected under the variable status, the user id of the requester and the requestee.
1. [Get Endpoints](#get-friend-request-endpoints)
2. [Post Endpoints](#post-friend-request-endpoints)
3. [Put Endpoints](#put-friend-request-endpoints)
---
### Get Friend Request Endpoints
#### Get All Friend Requests for a User
- http://localhost:8080/api/friendRequests/{userID}
- Your response should be a 200 OK with a JSON 
```
	[
		{
			"id": 1,
			"fromUserID": 1,
			"toUserID": 2,
			"Status": "PENDING"
		},
		{
			"id": 2,
			"fromUserID": 1,
			"toUserID": 3,
			"Status": "ACCEPTED"
		},
		{
			"id": 3,
			"fromUserID": 1,
			"toUserID": 4,
			"Status": "REJECTED"
		}
	]
```
---
### Post Friend Request Endpoints
#### Send a Friend Request to a User
- http://localhost:8080/api/friendRequests
- Your body should include the user ID of who to send it to and who it is from at the very least
```
	{
		"fromUserID": 1,
		"toUserID": 2
	}
```
- Your response should be a 201 CREATED with a JSON
```
	{
		"id": 1,
		"fromUserID": 1,
		"toUserID": 2,
		"Status": "PENDING"
	}
```
---
### Put Friend Request Endpoints
#### Accept a Friend Request
- http://localhost:8080/api/friendRequests/accept
- Your body should include the Friend Request ID 
```
	{
		"id": 1
	}
```
- Your response should be a 200 OK with a JSON 
```
	{
		"id": 1,
		"fromUserID": 1,
		"toUserID": 2,
		"Status": "ACCEPTED"
	}
```
---
#### Reject a Friend Request
- http://localhost:8080/api/friendRequests/reject
- Your body should include the Friend Request ID 
```
	{
		"id": 1
	}
```
- Your response should be a 200 OK with a JSON 
```
	{
		"id": 1,
		"fromUserID": 1,
		"toUserID": 2,
		"Status": "REJECTED"
	}
```
---
## Authentication Endpoints
The authentication provides http responses to signup and login. The signup creates a new user while the login checks user credentials. 
1. [Post Endpoints](#post-authentication-endpoints)
	- [Signup](#signup) 
	- [Login](#login) 
---
### Post Authentication Endpoints
#### Signup 
- http://localhost:8080/api/signup
- Your body should include the username, email, and password
```
    {
        "name": "Him",
        "email": "him@mail.com",
        "password": "password"
    }
```
- The response should be a 201 CREATED with a JSON containing the _userID_
```
	1
```
---
#### Login 
- http://localhost:8080/api/login
- Your body should include the email, and password
```
    {
        "email": "him@mail.com",
        "password": "password"
    }
```
- The response should be a 200 OK with a JSON containing the _userID_
```
	1
```
---
- If the email already exists, it will return a 400 Bad Request with the message "Email already exists".
- If the name is null, it will return a 400 Bad Request with the message "Name cannot be empty".
- If the password is null or less than 8 characters long, it will return a 400 Bad Request with the message "Password must be at least 8 characters long".

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
- CI/CD with good unit testing

# Long Term Goals

- Add websockets for real time communications
- Be able to send and recieve pictures
    - Store images somehow for chatrooms
- Containerize using docker and docker compose
___
___





<center>Written and Setup by Taiga. 

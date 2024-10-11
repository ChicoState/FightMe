# Backend Setup Guide for New Install 

## First and foremost, you need to have Java, SpringBoot, PostgreSQL, and Postman installed on your computer.

1. Clone this repository to your computer.
2. With VScode, under the extensions tab, install SpringBoot Extension Pack and Java Extension Pack.
3. Install PostgreSQL 15.8 or higher. 
    * For ease of use, I recommend keeping the username to postgres and setting the password to abc123.
    * Keep the port to 5432.
    * Keep cluseter local 
    * Launch PostgreSQL. Under Servers / PostgreSQL, right click on **Databases** , click **Create** and click **Database...** and set the name to **UserDB**. Keep everything else as default.
    * For later on, If you want to view the database, go to Servers / PostgreSQL / Databases / UserDB / Schemas / Public / Tables and you should see all your tables. From there, you can right click on one of your tables and click **View/Delete Data** then **All Rows** and then you should see your stuff. You can also refresh as well but you can find that.
4. Install [Postman](https://www.postman.com/downloads/)
    * You can use Postman to test your API endpoints.
    * Heres an example of one of the GET url endpoints: _http://localhost:8080/api/users/1_
    * For POST, make sure to select body / raw / JSON ~~instead of Text~~.

## To Run the Backend

1. Just click on one of the folders (i just use the BackendApplication.java file)
2. Click the run button on the top right corner of the file.
3. You should have a giant SPRING logo in the terminal in the beginning and it should be running. At the bottom of the terminal, you should see the port it is running on.
    * Like so _2024-10-04T00:43:04.697-07:00  INFO 59413 --- [backend] [  restartedMain] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port 8080 (http) with context path '/'
2024-10-04T00:43:04.710-07:00  INFO 59413 --- [backend] [  restartedMain] com.backend.backend.BackendApplication   : Started BackendApplication in 4.986 seconds (process running for 5.612)_

## Setting up the Database using Postman (Do in order) (Im not sure if this will work)

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
    * Heres an example of the JSON body for the POST request:
    With the URL being: http://localhost:8080/api/chatroom/1 on POST
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
      With URL being: http://localhost:8080/api/users/1 on PUT
      ```
       {
           "gamerScore": 100
       }
       ```
   * Heres an exmaple of adding User2 for User1:
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
## To Get this working with Flutter

1. Open PostgresSQL 
2. Run the Spring Boot Application
3. Run Flutter in command line
   * Use this command to save some time:  _flutter run -d chrome --web-port="60966"_

# Spring 2 Goals For Backend

- Integrate Websockets for real time communication
- User Authentication (JWT ???)
- Update/Delete requests for User/Messages/Chatroom
- Statistics for Games with leaderboard type thing
    - Maybe create separate file for user stats like UserStats and create leaderboard files (no entity b/c itll use UserStats)
- Implement Friends Feature (Creating friendRequest class)








Written and Setup by Taiga. 

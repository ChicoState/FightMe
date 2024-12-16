import 'dart:convert';

import 'package:fightme_webapp/Models/fight_game_session.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fightme_webapp/Models/httpservice.dart';
import 'package:fightme_webapp/Models/user.dart';
import 'package:fightme_webapp/Models/message.dart';
import 'package:fightme_webapp/Models/chatroom.dart';
import 'package:fightme_webapp/Models/friend_request.dart';
import 'package:fightme_webapp/Models/fight_game_session.dart';

class MockHttpClient extends Mock implements Client {}

class MockResponse extends Mock implements Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  final Client httpClient = MockHttpClient();
  final Response response = MockResponse();
  final Response response2 = MockResponse();
  final HttpService httpService = HttpService(httpClient: httpClient);

  setUpAll(() => registerFallbackValue(FakeUri()));

  test('Get all users', () async {
    when(() => httpClient.get(any())).thenAnswer((_) async => response);
    when(() => response.statusCode).thenReturn(200);
    when(() => response.body).thenReturn(
      jsonEncode([
        {
          "id": 1,
          "name": "Josh",
          "email": "Josh@mail.com",
          "password": "testpass123",
          "dateCreated": 0,
          "gamerScore": 0,
          "attackScore": 0,
          "defenseScore": 0,
          "magicScore": 0,
          "profilePicture": 0,
          "unlockedProfilePictures": [0],
          "theme": 0,
          "unlockedThemes": [0]
        },
        {
          "id": 2,
          "name": "Sara",
          "email": "Sara@mail.com",
          "password": "testpass123",
          "dateCreated": 0,
          "gamerScore": 0,
          "attackScore": 0,
          "defenseScore": 0,
          "magicScore": 0,
          "profilePicture": 0,
          "unlockedProfilePictures": [0],
          "theme": 0,
          "unlockedThemes": [0]
        },
      ]),
    );
    final users = await httpService.getUsers();
    expect(users.length, 2);
  });

  test('Get one user by id', () async {
    when(() => httpClient.get(any())).thenAnswer((_) async => response);
    when(() => response.statusCode).thenReturn(200);
    when(() => response.body).thenReturn(
      jsonEncode(
        {
          "id": 1,
          "name": "Josh",
          "email": "Josh@mail.com",
          "password": "testpass123",
          "dateCreated": 3,
          "gamerScore": 0,
          "attackScore": 0,
          "defenseScore": 0,
          "magicScore": 0,
          "profilePicture": 0,
          "unlockedProfilePictures": [0],
          "theme": 0,
          "unlockedThemes": [0]
        },
      ),
    );
    final user = await httpService.getUserByID(1);
    expect(user.name, "Josh");
    expect(user.dateCreated, 3);
  });

  test('Get friends', () async {
    when(() => httpClient
            .get(Uri.parse("http://localhost:8080/api/users/3/friends")))
        .thenAnswer((_) async => response);
    when(() => httpClient.get(Uri.parse("http://localhost:8080/api/users/1")))
        .thenAnswer((_) async => response2);
    when(() => response.statusCode).thenReturn(200);
    when(() => response2.statusCode).thenReturn(200);
    when(() => response.body).thenReturn(
      jsonEncode([1]),
    );
    when(() => response2.body).thenReturn(
      jsonEncode(
        {
          "id": 1,
          "name": "Josh",
          "email": "Josh@mail.com",
          "password": "testpass123",
          "dateCreated": 3,
          "gamerScore": 0,
          "attackScore": 0,
          "defenseScore": 0,
          "magicScore": 0,
          "profilePicture": 0,
          "unlockedProfilePictures": [0],
          "theme": 0,
          "unlockedThemes": [0]
        },
      ),
    );
    final users = await httpService.getFriends(3);
    expect(users.length, 1);
  });

  test('Get done games', () async {
    User user1 = User('John');
    User user2 = User('Sara');
    user2.id = 1;
    when(() => httpClient.get(any())).thenAnswer((_) async => response);
    when(() => response.statusCode).thenReturn(200);
    when(() => response.body)
        .thenReturn(jsonEncode([FightGameSession(user1, user2).toJson()]));
    final games = await httpService.getDoneGames(0);
    expect(games.length, 1);
    expect(games[0].user1.name, user1.name);
  });

  test('Get active games', () async {
    User user1 = User('John');
    User user2 = User('Sara');
    user2.id = 1;
    when(() => httpClient.get(any())).thenAnswer((_) async => response);
    when(() => response.statusCode).thenReturn(200);
    when(() => response.body)
        .thenReturn(jsonEncode([FightGameSession(user1, user2).toJson()]));
    final games = await httpService.getActiveGames(0);
    expect(games.length, 1);
    expect(games[0].user1.name, user1.name);
  });

  test("Signup User", () async {
    when(() => response.statusCode).thenReturn(201);
    when(() => response.body).thenReturn(jsonEncode(7));
    when(() => response.headers)
        .thenReturn({"Content-Type": "application/json"});
    //print(jsonEncode(7));
    when(() => httpClient.post(any(),
        body: any(named: 'body'),
        headers: any(named: 'headers'))).thenAnswer((_) async => response);

    final id =
        await httpService.signupUser("John", "john@mail.com", "testpass123");
    expect(id, 7);
  });

  test("Login User", () async {
    when(() => response.statusCode).thenReturn(200);
    when(() => response.body).thenReturn(jsonEncode(7));
    when(() => response.headers)
        .thenReturn({"Content-Type": "application/json"});
    //print(jsonEncode(7));
    when(() => httpClient.post(any(),
        body: any(named: 'body'),
        headers: any(named: 'headers'))).thenAnswer((_) async => response);

    final id = await httpService.loginUser("john@mail.com", "testpass123");
    expect(id, 7);
  });

  test("get Chatroom Messages", () async {
    Message testMessage = Message(1, 2, "Hello World!", 1);
    testMessage.timeStamp = 10;
    when(() => httpClient.get(any())).thenAnswer((_) async => response);
    when(() => response.statusCode).thenReturn(200);
    when(() => response.body).thenReturn(jsonEncode([testMessage.toJson()]));

    final messages = await httpService.getChatroomMessages(0);
    expect(messages.length, 1);
    expect(messages[0].content, "Hello World!");
  });

  test("get Chatrooms by User ID", () async {
    Chatroom testRoom = Chatroom("Chatroom1");
    User user1 = User('John');
    User user2 = User('Sara');
    user2.id = 1;
    Message testMessage = Message(1, 2, "Hello World!", 1);
    testMessage.timeStamp = 10;
    testRoom.users.add(user1);
    testRoom.users.add(user2);
    testRoom.messages.add(testMessage);

    when(() => httpClient.get(any())).thenAnswer((_) async => response);
    when(() => response.statusCode).thenReturn(200);
    when(() => response.body).thenReturn(jsonEncode([testRoom.toJson()]));

    final rooms = await httpService.getChatroomsByUserId(0);
    expect(rooms.length, 1);
    expect(rooms[0].users.length, 2);
    expect(rooms[0].messages.length, 1);
    expect(rooms[0].messages[0].content, "Hello World!");
  });

  test("get Friend Requests for User ID", () async {
    FriendRequest testRequest = FriendRequest.empty();
    testRequest.fromUserID = 1;
    testRequest.toUserID = 2;
    when(() => httpClient.get(any())).thenAnswer((_) async => response);
    when(() => response.statusCode).thenReturn(200);
    when(() => response.body).thenReturn(jsonEncode([testRequest.toJson()]));

    final requests = await httpService.getAllFriendRequests(0);
    expect(requests.length, 1);
    expect(requests[0].fromUserID, 1);
    expect(requests[0].toUserID, 2);
    expect(requests[0].status, Status.pending);
  });

  test("get sent Friend Requests for User ID", () async {
    FriendRequest testRequest = FriendRequest.empty();
    testRequest.fromUserID = 1;
    testRequest.toUserID = 2;

    when(() => httpClient.get(any())).thenAnswer((_) async => response);
    when(() => response.statusCode).thenReturn(200);
    when(() => response.body).thenReturn(jsonEncode([testRequest.toJson()]));

    final requests = await httpService.getAllSentRequests(1);
    expect(requests.length, 1);
    expect(requests[0].fromUserID, 1);
    expect(requests[0].toUserID, 2);
    expect(requests[0].status, Status.pending);
  });

  test("get Friend Request", () async {
    FriendRequest testRequest = FriendRequest.empty();
    testRequest.fromUserID = 1;
    testRequest.toUserID = 2;

    when(() => httpClient.get(any())).thenAnswer((_) async => response);
    when(() => response.statusCode).thenReturn(200);
    when(() => response.body).thenReturn(jsonEncode(testRequest.toJson()));

    final request = await httpService.getFriendRequest(1, 2);
    expect(request.fromUserID, 1);
    expect(request.toUserID, 2);
    expect(request.status, Status.pending);
  });

  test('Get all users', () async {
    when(() => httpClient.get(any())).thenAnswer((_) async => response);
    when(() => response.statusCode).thenReturn(200);
    when(() => response.body).thenReturn(
      jsonEncode([
        {
          "id": 1,
          "name": "Josh",
          "email": "Josh@mail.com",
          "password": "testpass123",
          "dateCreated": 0,
          "gamerScore": 0,
          "attackScore": 0,
          "defenseScore": 0,
          "magicScore": 0,
          "profilePicture": 0,
          "unlockedProfilePictures": [0],
          "theme": 0,
          "unlockedThemes": [0]
        },
        {
          "id": 2,
          "name": "Sara",
          "email": "Sara@mail.com",
          "password": "testpass123",
          "dateCreated": 0,
          "gamerScore": 0,
          "attackScore": 0,
          "defenseScore": 0,
          "magicScore": 0,
          "profilePicture": 0,
          "unlockedProfilePictures": [0],
          "theme": 0,
          "unlockedThemes": [0]
        },
      ]),
    );
    final users = await httpService.getSuggestedFriends(1);
    expect(users.length, 2);
    expect(users[0].name, "Josh");
    expect(users[1].name, "Sara");
  });

  test("post Fight Game", () async {
    User user1 = User('John');
    User user2 = User('Sara');
    user2.id = 1;
    FightGameSession testFight = FightGameSession(user1, user2);
    testFight.requesterID = user1.id;
    when(() => response.statusCode).thenReturn(201);
    when(() => response.body).thenReturn(jsonEncode(testFight.toJson()));
    when(() => response.headers)
        .thenReturn({"Content-Type": "application/json"});
    when(() => httpClient.post(any(),
        body: any(named: 'body'),
        headers: any(named: 'headers'))).thenAnswer((_) async => response);

    final game = await httpService.postFightGame(user1, user2, user1.id);
    expect(game.user1.name, user1.name);
    expect(game.user2.name, user2.name);
  });

  test('Get fight game', () async {
    User user1 = User('John');
    User user2 = User('Sara');
    user2.id = 1;
    FightGameSession testFight = FightGameSession(user1, user2);
    testFight.requesterID = user1.id;
    when(() => httpClient.get(any())).thenAnswer((_) async => response);
    when(() => response.statusCode).thenReturn(200);
    when(() => response.body).thenReturn(jsonEncode(testFight.toJson()));
    final game = await httpService.getFightGame(user1.id, user2.id);
    expect(game.user1.name, user1.name);
    expect(game.user2.name, user2.name);
  });
}

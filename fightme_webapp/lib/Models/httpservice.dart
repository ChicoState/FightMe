import 'dart:convert';

import 'package:http/http.dart' as http;
import 'chatroom.dart';
import 'user.dart';
import 'message.dart';
import 'friend_request.dart';
import 'package:fightme_webapp/globals.dart' as globals;
import 'fight_game_session.dart';

class HttpService {
  HttpService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  final String springbootUserURL = "http://localhost:8080/api/users/";
  final String springbootChatroomURL = "http://localhost:8080/api/chatroom/";
  final String springbootMessageURL = "http://localhost:8080/api/messages";
  final String springbootFriendRequestURL =
      "http://localhost:8080/api/friendrequests";
  final String springbootLoginURL = "http://localhost:8080/api/login";
  final String springbootSignupURL = "http://localhost:8080/api/signup";
  final String springbootFightGamesURL = "http://localhost:8080/api/fightgames";

  //retrieve a list of users from springboot
  Future<List<User>> getUsers() async {
    http.Response res = await _httpClient.get(Uri.parse(springbootUserURL));
    //print(res.body);
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<User> users =
          body.map((dynamic item) => User.fromJson(item)).toList();
      return users;
    } else {
      throw "Unable to retrieve user data.";
    }
  }

  Future<User> getUserByID(int id) async {
    http.Response res =
        await _httpClient.get(Uri.parse("$springbootUserURL$id"));
    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      User lookup = User.fromJson(body);
      return lookup;
    } else {
      throw "Unable to retrieve userID: $id";
    }
  }

  Future<List<User>> getFriends(int id) async {
    http.Response res =
        await _httpClient.get(Uri.parse("$springbootUserURL$id/friends"));
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<int> ids = List.from(body);
      List<User> friends = List.empty(growable: true);
      for (var id in ids) {
        friends.add(await getUserByID(id));
      }
      return friends;
    } else {
      throw "Unable to retrieve user data.";
    }
  }

  Future<List<FightGameSession>> getDoneGames(int id) async {
    http.Response res =
        await _httpClient.get(Uri.parse("$springbootUserURL$id/games"));
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<FightGameSession> doneGames =
          body.map((dynamic item) => FightGameSession.fromJson(item)).toList();
      return doneGames;
    } else {
      throw "Unable to retrieve user data.";
    }
  }

  Future<List<FightGameSession>> getActiveGames(int id) async {
    http.Response res =
        await _httpClient.get(Uri.parse("$springbootUserURL$id/vs"));
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<FightGameSession> activeGames =
          body.map((dynamic item) => FightGameSession.fromJson(item)).toList();
      return activeGames;
    } else {
      throw "Unable to retrieve user data.";
    }
  }

  Future<int> signupUser(String username, String email, String password) async {
    Map<String, dynamic> input = {
      'name': username,
      'email': email,
      'password': password,
    };
    http.Response res = await _httpClient.post(
      Uri.parse(springbootSignupURL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(input),
    );
    print(res.body);
    if (res.statusCode == 201) {
      print("User registered.");
      return int.parse(res.body);
    } else {
      print("Failed to register user.");
      return -1;
    }
  }

  Future<int> loginUser(String email, String password) async {
    Map<String, dynamic> input = {
      'email': email,
      'password': password,
    };
    http.Response res = await _httpClient.post(Uri.parse(springbootLoginURL),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(input) //{"email": email, "password": password},
        );
    print(res.body);
    if (res.statusCode == 200) {
      print("User credentials verified");
      return int.parse(res.body);
    } else {
      print("User verification failed");
      return -1;
    }
  }

  void postUser(User user) async {
    http.Response res = await _httpClient.post(Uri.parse(springbootUserURL),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()));
    print(res.body);
    if (res.statusCode == 201) {
      print("User created successfully.");
    } else {
      throw "Unable to create user.";
    }
  }

  Future<List<Message>> getChatroomMessages(int chatroomID) async {
    http.Response res =
        await _httpClient.get(Uri.parse("$springbootMessageURL/$chatroomID"));
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Message> messages =
          body.map((dynamic item) => Message.fromJson(item)).toList();
      return messages;
    } else {
      throw "Unable to retrieve message data for chatroom $chatroomID";
    }
  }

  Future<List<Chatroom>> getChatroomsByUserId(int userID) async {
    http.Response res = await _httpClient
        .get(Uri.parse("${springbootChatroomURL}user/$userID"));
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Chatroom> chatrooms =
          body.map((dynamic item) => Chatroom.fromJson(item)).toList();
      return chatrooms;
    } else {
      print("Status Code: ${res.statusCode}");
      throw "Unable to retrieve chatroom data for User $userID";
    }
  }

  Future<void> postChatroom(List<int> userIDs) async {
    http.Response res = await _httpClient.post(
        Uri.parse("${springbootChatroomURL}create"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userIds": userIDs}));
    print(res.body);
    if (res.statusCode == 201) {
      print("Chatroom created successfully.");
    } else {
      throw "Unable to create chatroom.";
    }
  }

  Future<void> postMessage(Message message) async {
    http.Response res = await _httpClient.post(Uri.parse(springbootMessageURL),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(message.toJson()));
    if (res.statusCode == 201) {
      print("Message posted successfully.");
    } else {
      print("Status Code: ${res.statusCode}");
      throw "Unable to post message to chatroom ${message.chatroomId}";
    }
  }

  //send a friend request to a user
  Future<void> sendFriendRequest(int fromUserID, int toUserID) async {
    http.Response res = await _httpClient.post(
        Uri.parse(springbootFriendRequestURL),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"fromUserID": fromUserID, "toUserID": toUserID}));
    if (res.statusCode == 201) {
      print("Friend request sent successfully.");
    } else {
      throw "Unable to send friend request.";
    }
  }

  //get all friend requests from a user
  Future<List<FriendRequest>> getAllFriendRequests(int userID) async {
    http.Response res =
        await _httpClient.get(Uri.parse("$springbootFriendRequestURL/$userID"));
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<FriendRequest> friendRequests =
          body.map((dynamic item) => FriendRequest.fromJson(item)).toList();
      return friendRequests;
    } else {
      print("Unable to retrieve friend request data for user $userID");
      return List.empty();
    }
  }

  Future<List<FriendRequest>> getAllSentRequests(int userID) async {
    http.Response res = await _httpClient
        .get(Uri.parse("$springbootFriendRequestURL/$userID/sent"));
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<FriendRequest> friendRequests =
          body.map((dynamic item) => FriendRequest.fromJson(item)).toList();
      return friendRequests;
    } else {
      print("Unable to retrieve friend request data for user $userID");
      return List.empty();
    }
  }

  Future<FriendRequest> getFriendRequest(int fromUserID, int toUserID) async {
    http.Response res = await _httpClient
        .get(Uri.parse("$springbootFriendRequestURL/$fromUserID/$toUserID"));
    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      FriendRequest friendRequest = FriendRequest.fromJson(body);
      return friendRequest;
    } else {
      print("Unable to retrieve friend request.");
      return FriendRequest.empty();
    }
  }

  //accept a friend request from a user
  Future<void> acceptFriendRequest(int friendRequestID) async {
    http.Response res = await _httpClient.put(
        Uri.parse("$springbootFriendRequestURL/accept"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": friendRequestID}));
    if (res.statusCode == 200) {
      print("Friend request accepted successfully.");
    } else {
      throw "Unable to accept friend request.";
    }
  }

  // reject a friend request from a user
  Future<void> rejectFriendRequest(int friendRequestID) async {
    http.Response res = await _httpClient.put(
        Uri.parse("$springbootFriendRequestURL/reject"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": friendRequestID}));
    if (res.statusCode == 200) {
      print("Friend request rejected successfully.");
    } else {
      throw "Unable to reject friend request.";
    }
  }

  //Get suggested list of users to add as friends
  Future<List<User>> getSuggestedFriends(int userID) async {
    http.Response res = await _httpClient
        .get(Uri.parse("$springbootUserURL$userID/suggestedFriends"));
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<User> suggestedFriends =
          body.map((dynamic item) => User.fromJson(item)).toList();
      return suggestedFriends;
    } else {
      throw "Unable to retrieve suggested friends for user $userID";
    }
  }

  //Update the user's stats
  Future<void> updateUserStats(int userID, Map<String, int> stats) async {
    http.Response res = await _httpClient.put(
        Uri.parse("$springbootUserURL$userID/stats"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(stats));
    if (res.statusCode == 200) {
      print("Stats updated successfully.");
    } else {
      throw "Unable to update user stats.";
    }
  }

  Future<void> updateUserGamerScore(int userID, int gamerScore) async {
    http.Response res = await _httpClient.put(
        Uri.parse("$springbootUserURL$userID/gamerScore"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"gamerScore": gamerScore}));
    if (res.statusCode == 200) {
      print("Gamer score updated successfully.");
    } else {
      throw "Unable to update user gamer score.";
    }
  }

  Future<void> updateUserProfilePicture(int userID, int profilePicture) async {
    http.Response res = await _httpClient.put(
        Uri.parse("$springbootUserURL$userID/profilePicture"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"profilePicture": profilePicture}));
    if (res.statusCode == 200) {
      print("Profile picture updated successfully.");
    } else {
      throw "Unable to update user profile picture.";
    }
  }

  Future<void> addUserProfilePicture(int userID, int profilePicture) async {
    http.Response res = await _httpClient.put(
        Uri.parse("$springbootUserURL$userID/addProfilePicture"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"profilePicture": profilePicture}));
    if (res.statusCode == 200) {
      print("Profile picture added successfully.");
    } else {
      throw "Unable to add user profile picture.";
    }
  }

  Future<void> updateUserTheme(int userID, int theme) async {
    http.Response res = await _httpClient.put(
        Uri.parse("$springbootUserURL$userID/theme"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"theme": theme}));
    if (res.statusCode == 200) {
      print("Theme updated successfully.");
    } else {
      throw "Unable to update user theme.";
    }
  }

  Future<void> addUserTheme(int userID, int theme) async {
    http.Response res = await _httpClient.put(
        Uri.parse("$springbootUserURL$userID/addTheme"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"theme": theme}));
    if (res.statusCode == 200) {
      print("Theme added successfully.");
    } else {
      throw "Unable to add user theme.";
    }
  }

  Future<FightGameSession> postFightGame(
      User user1, User user2, int requesterID) async {
    http.Response res = await _httpClient.post(
        Uri.parse(springbootFightGamesURL),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user1": user1.toJson(),
          "user2": user2.toJson(),
          "requesterID": requesterID
        }));
    print(res.body);
    if (res.statusCode == 201) {
      print("Game created successfully.");
      dynamic body = jsonDecode(res.body);
      FightGameSession fightGameSession = FightGameSession.fromJson(body);
      return fightGameSession;
    } else {
      print("Unable to create game session.");
      return FightGameSession.practice(globals.curUser);
    }
  }

  Future<FightGameSession> getFightGame(int user1ID, int user2ID) async {
    http.Response res = await _httpClient
        .get(Uri.parse("$springbootFightGamesURL/$user1ID/$user2ID"));
    if (res.statusCode == 200) {
      print(res.body);
      dynamic body = jsonDecode(res.body);
      FightGameSession fightGameSession = FightGameSession.fromJson(body);
      print("${fightGameSession.id}");
      return fightGameSession;
    } else {
      print("Unable to retrieve game session.");
      return FightGameSession.practice(globals.curUser);
    }
  }

  Future<void> setMove(int gameID, int userID, Move move) async {
    http.Response res = await _httpClient.put(
        Uri.parse("$springbootFightGamesURL/$gameID/setMove"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {"userID": userID, "move": move.name.toString().toUpperCase()}));
    if (res.statusCode == 200) {
      print("Move set successfully.");
    } else {
      print(move.name.toString());
      print("$userID");
      throw "Unable to set move.";
    }
  }

  Future<void> setNewTurn(FightGameSession game) async {
    http.Response res = await _httpClient.put(
        Uri.parse("$springbootFightGamesURL/newTurn"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(game.toJson()));
    if (res.statusCode == 200) {
      print("New turn set successfully.");
    } else {
      throw "Unable to set new turn.";
    }
  }

  Future<void> declareWinner(int gameID) async {
    http.Response res = await _httpClient.put(
        Uri.parse("$springbootFightGamesURL/$gameID/winner"),
        headers: {"Content-Type": "application/json"});
    if (res.statusCode == 200) {
      print("Winner set successfully.");
    } else {
      throw "Unable to set a winner.";
    }
  }
}

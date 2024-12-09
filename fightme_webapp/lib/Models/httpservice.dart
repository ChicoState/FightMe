import 'dart:convert';

import 'package:http/http.dart';
import 'chatroom.dart';
import 'user.dart';
import 'message.dart';
import 'friend_request.dart';

class HttpService {
  final String springbootUserURL = "http://localhost:8080/api/users/";
  final String springbootChatroomURL = "http://localhost:8080/api/chatroom/";
  final String springbootMessageURL = "http://localhost:8080/api/messages";
  final String springbootFriendRequestURL =
      "http://localhost:8080/api/friendrequests";
  final String springbootLoginURL = "http://localhost:8080/api/login";
  final String springbootSignupURL = "http://localhost:8080/api/signup";

  //retrieve a list of users from springboot
  Future<List<User>> getUsers() async {
    Response res = await get(Uri.parse(springbootUserURL));
    print(res.body);
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
    Response res = await get(Uri.parse("$springbootUserURL$id"));
    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      User lookup = User.fromJson(body);
      return lookup;
    } else {
      throw "Unable to retrieve userID: $id";
    }
  }

  Future<List<User>> getFriends(int id) async {
    Response res = await get(Uri.parse("$springbootUserURL$id/friends"));
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

  Future<int> signupUser(String username, String email, String password) async {
    Map<String, dynamic> input = {
      'name': username,
      'email': email,
      'password': password,
    };
    Response res = await post(
      Uri.parse(springbootSignupURL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(input),
    );
    print(res.body);
    if (res.statusCode == 200) {
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
    Response res = await post(Uri.parse(springbootLoginURL),
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
    Response res = await post(Uri.parse(springbootUserURL),
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
    Response res = await get(Uri.parse("${springbootMessageURL}/$chatroomID"));
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
    Response res = await get(Uri.parse("${springbootChatroomURL}user/$userID"));
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
    Response res = await post(Uri.parse("${springbootChatroomURL}create"),
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
    Response res = await post(Uri.parse(springbootMessageURL),
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
    Response res = await post(Uri.parse(springbootFriendRequestURL),
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
    Response res = await get(Uri.parse("$springbootFriendRequestURL/$userID"));
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
    Response res = await get(Uri.parse("$springbootFriendRequestURL/$fromUserID/$toUserID"));
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
    Response res = await put(Uri.parse("$springbootFriendRequestURL/accept"),
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
    Response res = await put(Uri.parse("$springbootFriendRequestURL/reject"),
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
    Response res =
        await get(Uri.parse("$springbootUserURL$userID/suggestedFriends"));
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
    Response res = await put(Uri.parse("$springbootUserURL$userID/stats"),
        headers: {"Content-Type": "application/json"}, body: jsonEncode(stats));
    if (res.statusCode == 200) {
      print("Stats updated successfully.");
    } else {
      throw "Unable to update user stats.";
    }
  }

  Future<void> updateUserGamerScore(int userID, int gamerScore) async {
    Response res = await put(Uri.parse("$springbootUserURL$userID/gamerScore"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"gamerScore": gamerScore}));
    if (res.statusCode == 200) {
      print("Gamer score updated successfully.");
    } else {
      throw "Unable to update user gamer score.";
    }
  }

  Future<void> updateUserProfilePicture(int userID, int profilePicture) async {
    Response res = await put(Uri.parse("$springbootUserURL$userID/profilePicture"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"profilePicture": profilePicture}));
    if (res.statusCode == 200) {
      print("Profile picture updated successfully.");
    } else {
      throw "Unable to update user profile picture.";
    }
  }

  Future<void> addUserProfilePicture(int userID, int profilePicture) async {
    Response res = await put(Uri.parse("$springbootUserURL$userID/addProfilePicture"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"profilePicture": profilePicture}));
    if (res.statusCode == 200) {
      print("Profile picture added successfully.");
    } else {
      throw "Unable to add user profile picture.";
    }
  }

  Future<void> updateUserTheme(int userID, int theme) async {
    Response res = await put(Uri.parse("$springbootUserURL$userID/theme"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"theme": theme}));
    if (res.statusCode == 200) {
      print("Theme updated successfully.");
    } else {
      throw "Unable to update user theme.";
    }
  }

  Future<void> addUserTheme(int userID, int theme) async {
    Response res = await put(Uri.parse("$springbootUserURL$userID/addTheme"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"theme": theme}));
    if (res.statusCode == 200) {
      print("Theme added successfully.");
    } else {
      throw "Unable to add user theme.";
    }
  }
}

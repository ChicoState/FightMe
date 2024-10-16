import 'dart:convert';

import 'package:http/http.dart';

import 'user.dart';
import 'message.dart';
import 'friend_request.dart';

class HttpService {
  final String springbootUserURL = "http://localhost:8080/api/users/";
  final String springbootChatroomURL = "http://localhost:8080/api/chatroom/";
  final String springbootMessageURL = "http://localhost:8080/api/messages";
  final String springbootFriendRequestURL = "http://localhost:8080/api/friendrequests";

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
      throw "Unable to retrive user data.";
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
    Response res = await post(Uri.parse("$springbootFriendRequestURL$fromUserID"),
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
      throw "Unable to retrieve friend request data for user $userID";
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
}

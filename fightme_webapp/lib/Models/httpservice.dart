import 'dart:convert';

import 'package:http/http.dart';

import 'user.dart';
import 'message.dart';

class HttpService {
  final String springbootUserURL = "http://localhost:8080/api/users/";
  final String springbootChatroomURL = "http://localhost:8080/api/chatroom/";
  final String springbootMessageURL = "http://localhost:8080/api/messages";

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

  void postMessage(Message message) async {
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
}

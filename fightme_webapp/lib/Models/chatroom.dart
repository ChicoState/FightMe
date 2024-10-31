import 'user.dart';
import 'message.dart';


class Chatroom{
  int id = 0;
  List<User> users = [];
  List<Message> messages = [];

  Chatroom.fromJson(Map<String, dynamic> json){
    id = json['id'];
    users = [];
    messages = [];

    for(var userJson in json['users']){
      users.add(User.fromJson(userJson));
    }

    if(json['messages'] != null){
      for(var messageJson in json['messages']){
        messages.add(Message.fromJson(messageJson));
      }
    }
  }

  Map<String, dynamic> toJson(){
    List<Map<String, dynamic>> messagesToJson = [];
    for(var message in messages){
      messagesToJson.add(message.toJson());
    }
    return{
      'id': id,
      'users': users,
      'messages': messagesToJson,
    };
  }

  Chatroom(String n){
    id = 0;
    users = [];
    messages = [];
  }
}

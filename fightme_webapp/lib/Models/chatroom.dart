import 'user.dart';
import 'message.dart';


class Chatroom{
  int id = 0;
  String name = "";
  List<Message> messages = [];

  Chatroom.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    messages = [];
    
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
      'name': name,
      'messages': messagesToJson,
    };
  }

  Chatroom(String n){
    id = 0;
    name = n;
    messages = [];
  }
}

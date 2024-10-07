import 'package:flutter/material.dart';

import 'Models/httpservice.dart';
import 'Models/message.dart';

class ChatPage extends StatefulWidget {
  final int chatroomID;
  final int userID;
  const ChatPage({super.key, required this.chatroomID, required this.userID});

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  late List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    HttpService().getChatroomMessages(widget.chatroomID).then((value) {
      setState(() {
        messages = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User ${widget.userID}"),
      ),
      body: Center(
        child: messagesView(),
      ),
    );
  }

  messagesView() => ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return Column(children: <Widget>[
          ListTile(
            title: Text(messages[index].content),
            subtitle: Text("User ${messages[index].fromId}"),
          )
        ]);
      });
}

import 'package:flutter/material.dart';

import 'Models/httpservice.dart';
import 'Models/message.dart';
import 'Models/user.dart';
import 'Widgets/fightButton.dart';

class ChatPage extends StatefulWidget {
  final int chatroomID;
  final int currentUID;
  final int otherUID;
  final User currentUser;
  final User otherUser;
  const ChatPage(
      {super.key,
      required this.chatroomID,
      required this.currentUser,
      required this.currentUID,
      required this.otherUser,
      required this.otherUID});

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  late List<Message> messages = [];
  TextEditingController textEditControl = TextEditingController();

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
        title: Text("User ${widget.currentUID}"),
      ),
      body: Center(
        child: Column(
          children: [
            messagesView(),
            TextField(
              controller: textEditControl,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Message"),
              onSubmitted: (value) async {
                await HttpService().postMessage(Message(widget.otherUID,
                    widget.currentUID, value, widget.chatroomID));
                HttpService()
                    .getChatroomMessages(widget.chatroomID)
                    .then((onValue) {
                  setState(() {
                    messages = onValue;
                  });
                });
                textEditControl.clear();
              },
            ),
            buildFightButton(context, widget.currentUser, widget.otherUser),
          ],
        ),
      ),
    );
  }

  messagesView() => ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
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

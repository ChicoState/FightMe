import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'Models/httpservice.dart';
import 'Models/message.dart';
import 'Models/user.dart';
import 'profile_page.dart';
import 'Widgets/fightButton.dart';
import 'package:fightme_webapp/Models/fight_game_session.dart';
import 'dart:math';


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

  late int randomNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,
        title: FilledButton.tonal(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute<ProfilePage>(
                    builder: (context) => ProfilePage(
                        curUser: widget.currentUser,
                        userViewed: widget.otherUser)));
          },
          child: Text(widget.otherUser.name),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () =>
                  buildFightButton(context, FightGameSession(widget.currentUser, widget.otherUser)),
                child: const Text('Fight!')
            ),
            Expanded(
              child: messagesView(),
            ),
            TextField(
              controller: textEditControl,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Message"),
              onSubmitted: (value) async {
                await HttpService().postMessage(Message(widget.otherUID,
                    widget.currentUID, value, widget.chatroomID));
                randomNumber = Random().nextInt(100);
                if(randomNumber < 50) {
                  print("I recieved $randomNumber, increase");
                  await HttpService().updateUserGamerScore(widget.currentUID, widget.currentUser.gamerScore + 1);
                }
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
            subtitle: Text(messages[index].fromId == widget.currentUser.id ? widget.currentUser.name : widget.otherUser.name),
          )
        ]);
      });
}

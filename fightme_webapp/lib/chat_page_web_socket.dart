import 'dart:convert';
import 'package:fightme_webapp/Models/httpservice.dart';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'globals.dart' as globals;
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

  const ChatPage({
    super.key,
    required this.chatroomID,
    required this.currentUser,
    required this.currentUID,
    required this.otherUser,
    required this.otherUID,
  });

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  late StompClient stompClient;
  late TextEditingController textEditControl;
  late List<Message> messages = [];
  late int randomNumber;

  @override
  void initState() {
    super.initState();
    HttpService().getChatroomMessages(widget.chatroomID).then((value) {
      setState(() {
        messages = value;
      });
    });

    textEditControl = TextEditingController();

    // Initialize WebSocket connection and STOMP client
    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://localhost:8080/ws',
        onConnect: (StompFrame frame) {
          stompClient.subscribe(
            destination: '/topic/chatroom/${widget.chatroomID}',
            callback: (StompFrame frame) {
              setState(() {
                if (frame.body != null) {
                  // Handle incoming messages
                  messages.add(Message.fromJson(jsonDecode(frame.body!)));
                }
              });
            },
          );
        },
        onWebSocketError: (error) {
          print('WebSocket Error: $error');
        },
        onStompError: (error) {
          print('STOMP Error: $error');
        },
      ),
    );
    stompClient.activate();
  }

  @override
  void dispose() {
    // Close WebSocket connection on dispose
    stompClient.deactivate();
    super.dispose();
  }

  void _sendMessage(String messageContent) {
    if (messageContent.isNotEmpty) {
      stompClient.send(
        destination: '/app/chat.sendMessage/${widget.chatroomID}',
        body: jsonEncode({
          'chatroomId': widget.chatroomID,
          'content': messageContent,
          'toId': widget.otherUID,
          'fromId': widget.currentUID,
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: FilledButton.tonal(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<ProfilePage>(
                builder: (context) => ProfilePage(
                  curUser: widget.currentUser,
                  userViewed: widget.otherUser,
                ),
              ),
            );
          },
          child: Text(widget.otherUser.name),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => buildFightButton(
                context,
                FightGameSession(widget.currentUser, widget.otherUser),
              ),
              child: const Text('Fight!'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(messages[index].content),
                    subtitle: Text(
                      messages[index].fromId == widget.currentUser.id
                          ? widget.currentUser.name
                          : widget.otherUser.name,
                    ),
                  );
                },
              ),
            ),
            TextField(
              controller: textEditControl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Message",
              ),
              onSubmitted: (value) async {
                _sendMessage(value); // Send message via WebSocket
                print("Are we here?");
                randomNumber = Random().nextInt(100);
                if (randomNumber < 50) {
                  print("I received $randomNumber, increase");
                  // Optionally update score (or any other game-related logic)
                  await HttpService().updateUserGamerScore(
                      widget.currentUID, widget.currentUser.gamerScore + 1);
                }
                textEditControl.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}
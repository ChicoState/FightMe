import 'package:flutter/material.dart';

import 'conversation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.curUser});

  final String curUser;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Conversation> _conversations = [
    Conversation(
        recipientUID: 1234,
        recipientUsername: "Bob",
        recipientScore: 321,
        lastMessage: "Hello world!"),
    Conversation(
        recipientUID: 4321,
        recipientUsername: "Joey",
        recipientScore: 700,
        lastMessage: "Let's fight")
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.curUser),
      ),
      body: Center(
        child: _conversationsView(),
      ),
    );
  }

  _conversationsView() => ListView.builder(
      itemCount: _conversations.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            ListTile(
                leading: Text(_conversations[index].recipientScore.toString()),
                title: Text(_conversations[index].recipientUsername),
                subtitle: Text((_conversations[index].lastMessage == '')
                    ? "No messages"
                    : _conversations[index].lastMessage),
                onTap: () {}),
          ],
        );
      });
}

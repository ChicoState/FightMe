import 'dart:convert';
import 'package:http/http.dart';
import 'chat_page.dart';
import 'Models/chatroom.dart';
import 'Models/message.dart';
import 'Models/user.dart';
import 'Models/httpservice.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _myController = TextEditingController();
  String entertext = "";

  void _changeText() {
    setState(() {
      entertext = _myController.text;
      HttpService().postUser(User(entertext));
      _myController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            const Text(
              'Select Current User:',
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<ChatPage>(
                          builder: (context) => const ChatPage(
                              chatroomID: 1, userID: 1, otherID: 2)));
                },
                child: const Text('User 1')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<ChatPage>(
                          builder: (context) => const ChatPage(
                              chatroomID: 1, userID: 2, otherID: 1)));
                },
                child: const Text('User 2')),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

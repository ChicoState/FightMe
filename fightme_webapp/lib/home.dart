import 'dart:convert';
import 'package:http/http.dart';
import 'chat_page.dart';
import 'navbar.dart';
import 'Models/chatroom.dart';
import 'Models/message.dart';
import 'Models/user.dart';
import 'Models/httpservice.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _HomeState();
}

class _HomeState extends State<home> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  String checkLoggedIn = "Not Logged In";
  String entertext = "";

  // void _changeText() {
  //   setState(() {
  //     entertext = _myController.text;
  //     HttpService().postUser(User(entertext));
  //     _myController.text = "";
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Fight Me"),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            Text(checkLoggedIn),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                hintText: "Username",
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: "Email",
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: "Password",
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  globals.uid = await HttpService().loginUser(
                      _emailController.text, _passwordController.text);
                  if (globals.uid >= 0) {
                    globals.curUser =
                        await HttpService().getUserByID(globals.uid);
                    checkLoggedIn = "Logged in as: ${globals.curUser.name}";
                  } else {
                    checkLoggedIn = "Email/Password did not match.";
                  }
                },
                child: const Text("Login")),
            ElevatedButton(
                onPressed: () async {
                  globals.uid = await HttpService().signupUser(
                      _usernameController.text,
                      _emailController.text,
                      _passwordController.text);
                  if (globals.uid >= 0) {
                    globals.curUser =
                        await HttpService().getUserByID(globals.uid);
                    checkLoggedIn =
                        "Account created. Logged in as ${globals.curUser.name}";
                  } else {
                    checkLoggedIn = "Could not create account.";
                  }
                },
                child: const Text("Register")),
            // const Text(
            //   'Select Current User:',
            // ),
            // ElevatedButton(
            //     onPressed: () async {
            //       User curUser = await HttpService().getUserByID(1);
            //       User otherUser = await HttpService().getUserByID(2);
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute<ChatPage>(
            //               builder: (context) => ChatPage(
            //                     chatroomID: 1,
            //                     currentUser: curUser,
            //                     currentUID: curUser.id,
            //                     otherUser: otherUser,
            //                     otherUID: otherUser.id,
            //                   )));
            //     },
            //     child: const Text('User 1')),
            // ElevatedButton(
            //     onPressed: () async {
            //       User curUser = await HttpService().getUserByID(2);
            //       User otherUser = await HttpService().getUserByID(1);
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute<ChatPage>(
            //               builder: (context) => ChatPage(
            //                   chatroomID: 1,
            //                   currentUser: curUser,
            //                   currentUID: curUser.id,
            //                   otherUser: otherUser,
            //                   otherUID: otherUser.id)));
            //     },
            //     child: const Text('User 2')),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart';
import 'chat_page.dart';
import 'Models/chatroom.dart';
import 'Models/message.dart';
import 'Models/user.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class HttpService {
  final String springbootUserURL = "http://localhost:8080/api/users/";
  final String springbootChatroomURL = "http://localhost:8080/api/chatroom/";
  final String springbootMessageURL = "http://localhost:8080/api/messages/";

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
    Response res = await get(Uri.parse("$springbootMessageURL$chatroomID"));
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Message> messages =
          body.map((dynamic item) => Message.fromJson(item)).toList();
      return messages;
    } else {
      throw "Unable to retrieve message data for chatroom $chatroomID";
    }
  }
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
              'the text you entered:',
            ),
            Text(
              entertext,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'enter text',
                hintText: 'type stuff here',
              ),
              controller: _myController,
            ),
            ElevatedButton(
                onPressed: _changeText,
                child: const Text('change text and send user')),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: FutureBuilder(
                  future: HttpService().getUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                                "${snapshot.data![index].name} - ${snapshot.data![index].email} - ${snapshot.data![index].password}"),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeText,
        tooltip: 'Increment',
        child: const Icon(Icons.edit),
      ),
    );
  }
}

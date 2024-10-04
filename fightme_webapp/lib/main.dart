import 'dart:convert';
//import 'package:fightme_webapp/flutter/examples/api/lib/material/autocomplete/autocomplete.1.dart';
import 'package:http/http.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class User {
  int id = 0;
  String name = "";
  String email = "";
  String password = "";
  int dateCreated = 0;
  int gamerScore = 0;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    dateCreated = json['dateCreated'];
    gamerScore = json['gamerScore'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'dateCreated': dateCreated,
      'gamerScore': gamerScore,
    };
  }
}

class HttpService {
  final String springbootURL = "http://localhost:8080/api/users";
  //retrieve a list of users from springboot
  Future<List<User>> getUsers() async {
    Response res = await get(Uri.parse(springbootURL));
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
    Response res =
        await post(Uri.parse(springbootURL), body: jsonEncode(user.toJson()));
    print(res.body);
    if (res.statusCode == 201) {
      print("User created successfully.");
    } else {
      throw "Unable to create user.";
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
      HttpService().sendUser(entertext);
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

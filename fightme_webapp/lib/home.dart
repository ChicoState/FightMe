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
    if (globals.loggedIn) {
      setState(() {
        checkLoggedIn = "Logged in as: ${globals.curUser.name}";
      });
    } else {
      setState(() {
        checkLoggedIn = "Not Logged In";
      });
    }
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
                  if (globals.uid > 0) {
                    globals.curUser =
                        await HttpService().getUserByID(globals.uid);
                    globals.loggedIn = true;
                    setState(() {
                      checkLoggedIn = "Logged in as: ${globals.curUser.name}";
                    });
                  } else {
                    globals.loggedIn = false;
                    setState(() {
                      checkLoggedIn = "Email/Password did not match.";
                    });
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
                    globals.loggedIn = true;
                    setState(() {
                      checkLoggedIn =
                          "Account created. Logged in as ${globals.curUser.name}";
                    });
                  } else {
                    globals.loggedIn = false;
                    setState(() {
                      checkLoggedIn = "Could not create account.";
                    });
                  }
                },
                child: const Text("Register")),
            ElevatedButton(
                onPressed: () {
                  globals.loggedIn = false;
                  globals.uid = 0;
                  globals.curUser = User("");
                  setState(() {
                    checkLoggedIn = "Not Logged In";
                  });
                },
                child: const Text("Logout")),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

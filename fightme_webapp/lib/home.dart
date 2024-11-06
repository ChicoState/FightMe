import 'package:fightme_webapp/Models/httpservice.dart';
import 'package:fightme_webapp/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'navbar.dart'; // Assuming this is your main app page after login
import 'globals.dart' as globals;
import 'Models/httpservice.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String checkLoggedIn = "";

  @override
  void initState() {
    super.initState();
    _loadUserData().then((_) {
      if (globals.loggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => navbar(
              curUser: globals.curUser!,
              initialIndex: 1,
            ),
          ),
        );
      }
    });
  }

  Future<void> _saveUserData(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId); // Save user ID
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');
    
    if (userId != 0 && userId != null) {
      globals.uid = userId;
      globals.curUser = await HttpService().getUserByID(userId);
      globals.loggedIn = true;
    } else {
      globals.loggedIn = false;
    }
  }

  Future<void> loginUser() async {
    globals.uid = await HttpService().loginUser(
      _emailController.text,
      _passwordController.text,
    );

    if (globals.uid != null && globals.uid! > 0) {
      globals.curUser = await HttpService().getUserByID(globals.uid!);
      globals.loggedIn = true;
      await _saveUserData(globals.uid!);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => navbar(
            curUser: globals.curUser!,
            initialIndex: 1,
          ),
        ),
        (route) => false,
      );
    } else {
      globals.loggedIn = false;
      setState(() {
        checkLoggedIn = "Email/Password did not match.";
      });
    }
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    globals.uid = 0;
    globals.curUser = User("");
    globals.loggedIn = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: loginUser,
                child: const Text('Login'),
              ),
              if (checkLoggedIn.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    checkLoggedIn,
                    style: const TextStyle(color: Colors.red),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

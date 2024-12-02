import 'package:fightme_webapp/Models/httpservice.dart';
import 'package:fightme_webapp/Models/user.dart';
import 'package:fightme_webapp/Providers/stats_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'navbar.dart'; // Assuming this is your main app page after login
import 'globals.dart' as globals;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String checkLoggedIn = "";
  Color textColor = Colors.blue;

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
    }
    );
  }

  Future<void> _saveUserData(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');
    
    if (userId != 0 && userId != null) {
      globals.uid = userId;
      globals.curUser = await HttpService().getUserByID(userId);
      globals.loggedIn = true;
      final statsProvider = Provider.of<StatsProvider>(context, listen: false);
      await statsProvider.initializeStats(globals.curUser);
      // final friendsProvider = Provider.of<FriendsProvider>(context, listen: false);
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
      globals.curUser = await HttpService().getUserByID(globals.uid);
      globals.loggedIn = true;
      await _saveUserData(globals.uid);
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              // "Fight Me" title
              const Text(
                'Fight Me',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40.0),

              // Row for Image and Login form
              Expanded(
                child: Row(
                  children: [
                    // Placeholder Image - takes up half the screen height
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: loginUser,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          if (checkLoggedIn.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                checkLoggedIn,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          const SizedBox(height: 16.0),
                          MouseRegion(
                            onHover: (_) {
                              setState(() {
                                textColor = Colors.grey;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                textColor = Colors.blue;
                              });
                            },
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUp(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String checkSignedUp = "";
  Color textColor = Colors.blue;


  Future<void> _saveUserData(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId); // Save user ID
  }

  Future<void> signUpUser() async {
    // Simulate API call for user signup
    final int userId = await HttpService().signupUser(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );

    if (userId > 0) {
      globals.curUser = await HttpService().getUserByID(userId);
      globals.loggedIn = true;
      await _saveUserData(userId);
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
        checkSignedUp = "Sign Up failed. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              // "Fight Me" title
              const Text(
                'Fight Me',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40.0),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: Icon(
                        Icons.person_add,
                        size: 100,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: 'Username',
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: signUpUser,
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          if (checkSignedUp.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                checkSignedUp,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          const SizedBox(height: 16.0),
                          MouseRegion(
                            onHover: (_) {
                              setState(() {
                                textColor = Colors.grey;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                textColor = Colors.blue;
                              });
                            },
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                            child: const Text(
                              'Already have an account? Login',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

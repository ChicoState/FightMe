import 'chat_page.dart';
import 'main.dart';
import 'home.dart';
import 'profile_page.dart';
import 'Models/user.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class navbar extends StatefulWidget {
  const navbar({super.key});

  @override
  State<navbar> createState() => _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState extends State<navbar> {
  int _selectedIndex = 1;
  static final List<Widget> _widgetOptions = <Widget>[
    //make call to page like this: home();
    MyApp(),
    home(),
    ProfilePage(curUser: curUser, userViewed: curUser),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}

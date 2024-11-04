import 'package:fightme_webapp/fight_game_page.dart';
import 'package:fightme_webapp/searchbar.dart';

import 'chat_page.dart';
import 'chats_master_page.dart';
import 'main.dart';
import 'home.dart';
import 'profile_page.dart';
import 'Models/user.dart';
import 'package:flutter/material.dart';
import 'package:fightme_webapp/Models/httpservice.dart';
import 'globals.dart' as globals;

class navbar extends StatefulWidget {
  final User curUser;
  const navbar({super.key, required this.curUser});

  @override
  State<navbar> createState() => _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState extends State<navbar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      //make call to page like this: home();
      const home(),
      ChatsMasterPage(curUser: globals.curUser),
      // const home(),
      FightGamePage(),
      ProfilePage(curUser: globals.curUser, userViewed: globals.curUser),
    ];
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'fight',
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

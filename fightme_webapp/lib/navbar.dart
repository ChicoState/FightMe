import 'package:fightme_webapp/gamerscore_shop.dart';
import 'package:fightme_webapp/chats_master_page.dart';
import 'package:fightme_webapp/training_area_page.dart';
import 'package:fightme_webapp/profile_page.dart';
import 'package:flutter/material.dart';
import 'Models/user.dart';

class navbar extends StatefulWidget {
  final User curUser;
  final int initialIndex; // Add this to control the initial tab

  const navbar({super.key, required this.curUser, this.initialIndex = 1});

  @override
  State<navbar> createState() => _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState extends State<navbar> {
  int _selectedIndex = 1; // Default to "Fight Game" page

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Set initial index
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      GamerscoreShop(curUser: widget.curUser),
      ChatsMasterPage(curUser: widget.curUser),
      TrainingAreaPage(curUser: widget.curUser),
      ProfilePage(curUser: widget.curUser, userViewed: widget.curUser),
    ];

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'Fight',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}

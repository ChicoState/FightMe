import 'package:fightme_webapp/fight_game_page.dart';

import 'chat_page.dart';
import 'navbar.dart';
import 'home.dart';
import 'Models/user.dart';
import 'Models/httpservice.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

User curUser = User("placeholder");

Future<void> main() async {
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
      home: globals.loggedIn ? const FightGamePage() : Home(),
    );
  }
}

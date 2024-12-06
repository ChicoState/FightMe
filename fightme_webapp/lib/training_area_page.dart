import 'package:fightme_webapp/Providers/settings_provider.dart';
import 'package:fightme_webapp/Providers/stats_provider.dart';
import 'package:fightme_webapp/dungeon_lobby.dart';
import 'package:flutter/material.dart';
import 'package:fightme_webapp/Models/user.dart';
import 'package:fightme_webapp/Models/fight_game_session.dart';
import 'package:provider/provider.dart';
import 'Widgets/fightButton.dart';
import 'package:fightme_webapp/fight_game_page.dart';
import 'globals.dart' as globals;
import "dart:math";

String mostSuccessfulMove(
    int successfulAttacks, int successfulDefenses, int successfulMagicAttacks) {
  if (successfulAttacks > successfulDefenses &&
      successfulAttacks > successfulMagicAttacks) {
    return "Attack";
  } else if (successfulDefenses > successfulAttacks &&
      successfulDefenses > successfulMagicAttacks) {
    return "Defense";
  } else {
    return "Magic";
  }
}

class TrainingAreaPage extends StatefulWidget {
  final User curUser;
  const TrainingAreaPage({super.key, required this.curUser});

  @override
  State<TrainingAreaPage> createState() => TrainingAreaPageState();
}

class TrainingAreaPageState extends State<TrainingAreaPage> {
  @override
  Widget build(BuildContext context) {
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Training Area"),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            ElevatedButton(
                onPressed: () {
                  buildFightButton(
                      context, FightGameSession.practice(widget.curUser));
                },
                child: const Text('Practice against a dummy')),
            ElevatedButton(
              onPressed: () {
                String pfp = settingsProvider.profilePicture.split('/').last;

                if (pfp.isEmpty) {
                  pfp = 'default-avatar.png';
                }
                Navigator.push(
                      context,
                      MaterialPageRoute<DungeonLobby>(
                          builder: (context) => const DungeonLobby()));
              },
              child: const Text("Enter the Dungeon Lobby"),
            ),
          ])),
    );
  }
}

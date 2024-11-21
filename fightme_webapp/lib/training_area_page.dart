import 'package:flutter/material.dart';
import 'package:fightme_webapp/Models/user.dart';
import 'package:fightme_webapp/Models/fight_game_session.dart';
import 'Widgets/fightButton.dart';
import 'package:fightme_webapp/fight_game_page.dart';
import 'globals.dart' as globals;
import "dart:math";


String mostSuccessfulMove(int successfulAttacks, int successfulDefenses, int successfulMagicAttacks) {
  if (successfulAttacks > successfulDefenses && successfulAttacks > successfulMagicAttacks) {
    return "Attack";
  }
  else if (successfulDefenses > successfulAttacks && successfulDefenses > successfulMagicAttacks) {
    return "Defense";
  }
  else {
    return "Magic";
  }
}

class TrainingAreaPage extends StatefulWidget {
  final User curUser;
  const TrainingAreaPage(
      {super.key, required this.curUser});

  @override
  State<TrainingAreaPage> createState() => TrainingAreaPageState();
}

class TrainingAreaPageState extends State<TrainingAreaPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .primary,
          title: const Text("Training Area"),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: ()
                      {
                        buildFightButton(context, FightGameSession.practice(widget.curUser));
                      },
                      child: const Text('Practice against a dummy')
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<FightGamePage>(
                              builder: (context) => const FightGamePage()));
                    },
                    child: const Text("Enter the Dungeon"),
                  ),
                ]
            )
        )
    );
  }
}
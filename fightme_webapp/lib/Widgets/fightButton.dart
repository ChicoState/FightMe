import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fightme_webapp/Models/user.dart';
import 'package:fightme_webapp/Models/fight_game_session.dart';

bool doesUserWin(User user1, User user2) {
  if (user1.gamerScore > user2.gamerScore) {
    return true;
  }
  else if (user1.gamerScore == user2.gamerScore) {
    var rng = Random();
    if (rng.nextInt(1) == 1) {
      return true;
    }
  }
  return false;
}

Widget buildFightButton(BuildContext context, User user1, User user2) {
  Move action = Move.none;
  List<Color> colors = [Colors.red, Colors.orangeAccent, Colors.amberAccent, Colors.yellowAccent[100]!, Colors.lightGreenAccent[400]!/*Why in God's name would this be Color? ?*/];
  int turn = 1;
  int user1hp = 5;
  int user2hp = 2;
  return FloatingActionButton(
      onPressed: () =>
          showDialog<String>(
            context: context,
            builder: (BuildContext context) =>
                StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CloseButton(),
                            Text("Turn $turn"),
                            IconButton(
                                onPressed: () =>
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text("Rules of the game"),
                                            content: const Text("Defense blocks attack.\nMagic bypasses defense\nAttack strikes before magic."),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, 'OK'),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                    ),
                                icon: const Icon(Icons.question_mark)
                            ),
                          ]
                      ),
                      content: SizedBox(
                        height: 200,
                        child: Column(
                            children: [
                              Text(user2.name, style: const TextStyle(fontSize: 20)),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                  children: [
                                    for (int i = 1;i <= 5;i++)
                                      i > 5 - user2hp ? Expanded(
                                        child: Container(
                                            height: 15.0,
                                            decoration: BoxDecoration(
                                              color: colors[user2hp-1],
                                              border: Border.all(color: Colors.black, width: 0.0),
                                            )
                                        ),
                                      ) :
                                      Expanded(
                                        child: Container(
                                          height: 15.0,
                                        ),
                                      ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text("HP"),
                                  ]
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                        children: [
                                          const Text("ATK", style: TextStyle(backgroundColor: Colors.red)),
                                          Text("${user2.attackScore}"),
                                        ]
                                    ),
                                    Column(
                                        children: [
                                          const Text("DEF", style: TextStyle(backgroundColor: Colors.blue)),
                                          Text("${user2.defenseScore}"),
                                        ]
                                    ),
                                    Column(
                                        children: [
                                          const Text("MP", style: TextStyle(backgroundColor: Colors.yellow)),
                                          Text("${user2.magicScore}"),
                                        ]
                                    ),
                                  ]
                              ),
                              const Align(
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.account_circle_sharp),
                              ),
                              const SizedBox(
                                height: 23,
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.account_circle_sharp),
                              ),
                              Row(
                                  children: [
                                    const Text("HP"),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    for (int i = 1;i <= 5;i++)
                                      i <= user1hp ? Expanded(
                                        child: Container(
                                            height: 15.0,
                                            decoration: BoxDecoration(
                                              color: colors[user1hp-1],
                                              border: Border.all(color: Colors.black, width: 0.0),
                                            )
                                        ),
                                      ) :
                                      Expanded(
                                        child: Container(
                                          height: 15.0,
                                        ),
                                      ),
                                  ]
                              ),
                            ]
                        ),
                      ),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: <Widget>[
                              action == Move.none ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    FloatingActionButton(
                                      onPressed: () {
                                        setState(() { action = Move.attack; });
                                      },
                                      backgroundColor: Colors.red,
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text('Attack'),
                                            Text("${user1.attackScore}"),
                                          ]
                                      ),
                                    ),
                                    FloatingActionButton(
                                      onPressed: () {
                                        setState(() { action = Move.defense; });
                                      },
                                      backgroundColor: Colors.blue,
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text('Defense'),
                                            Text("${user1.defenseScore}"),
                                          ]
                                      ),
                                    ),
                                    FloatingActionButton(
                                      onPressed: () {
                                        setState(() { action = Move.magic; });
                                      },
                                      backgroundColor: Colors.yellow,
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text('Magic'),
                                            Text("${user1.magicScore}"),
                                          ]
                                      ),
                                    ),
                                  ]
                              ) :
                              const Text("Waiting on opponent"),
                      ],
                    );
                  },
                ),
          ),
      tooltip: 'Fight!',
      child: const Text('Fight!')
  );
}
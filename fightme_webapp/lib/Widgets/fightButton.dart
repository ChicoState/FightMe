
import 'package:fightme_webapp/Cosmetics/profile_pictures.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fightme_webapp/Models/fight_game_session.dart';

List<Move> randomMove = [Move.attack, Move.defense, Move.magic];

Color moveColor(String move) {
  if (move == "assets/images/attack.png") {
    return Colors.red;
  }
  else if (move == "assets/images/defense.png") {
    return Colors.blue;
  }
  else {
    return Colors.yellow;
  }
}

String move(Move move) {
  if (move == Move.attack) {
    return "assets/images/attack.png";
  }
  else if (move == Move.defense) {
    return "assets/images/defense.png";
  }
  else {
    return "assets/images/magic.png";
  }
}

String endMessage(int user1hp, int user2hp) {
  if (user1hp != 0) {
    return "You win!";
  }
  else if (user2hp != 0) {
    return "You lose!";
  }
  else {
    return "It's a draw!";
  }
}

bool doesUserHit(Move move1, Move move2) {
  if (move1 != Move.defense) {
    if (move1 == move2) {
      return true;
    }
    if (move1 == Move.attack && move2 == Move.magic) {
      return true;
    }
    if (move1 == Move.magic && move2 == Move.defense) {
      return true;
    }
  }
  return false;
}

void buildFightButton(BuildContext context, FightGameSession game) {
  final random = Random();
  String whatUser1Did = "";
  String whatUser2Did = "";
  List<Color> colors = [Colors.red, Colors.orangeAccent, Colors.amberAccent, Colors.yellowAccent[100]!, Colors.lightGreenAccent[400]!/*Why in God's name would this be Color? ?*/];
  showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(
            builder: (context, setState) {
              if (game.user1move != Move.none) {
                if (game.user2.id == 0) {
                  game.user2move = randomMove[random.nextInt(randomMove.length)];
                }
                if (game.user2move != Move.none) {
                  if (doesUserHit(game.user1move, game.user2move)) {
                    game.user2hp--;
                  }
                  if (doesUserHit(game.user2move, game.user1move)) {
                    game.user1hp--;
                  }
                  whatUser1Did = move(game.user1move);
                  whatUser2Did = move(game.user2move);
                  game.turn++;
                  game.user1move = Move.none;
                  game.user2move = Move.none;
                }
              }
              if (game.user1hp == 0 || game.user2hp == 0) {
                return AlertDialog(
                    title: Text(endMessage(game.user1hp, game.user2hp)),
                    actionsAlignment: MainAxisAlignment.center,
                    content: Image.asset(game.user1hp != 0  ? profilePictures[game.user1.pfp] : profilePictures[game.user2.pfp], width: 60, height: 60),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ]
                );
              }
              return AlertDialog(
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CloseButton(),
                      Text("Turn ${game.turn}"),
                      IconButton(
                          onPressed: () =>
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    AlertDialog(
                                      title: const Text(
                                          "Rules of the game"),
                                      content: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset("assets/images/fight_game_rules.png", width: 200, height: 200),
                                            const SizedBox(
                                                width: 200,
                                                child: Text("A poorly matched move is not always a failure. Train your skills to increase your chances of a successful counter.", textAlign: TextAlign.center,)
                                            ),
                                          ]
                                      ),
                                      actionsAlignment: MainAxisAlignment.center,
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(
                                                  context, 'OK'),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                              ),
                          icon: const Icon(Icons.question_mark)
                      ),
                    ]
                ),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(game.user2.name,
                          style: const TextStyle(fontSize: 20)),
                      Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceEvenly,
                          children: [
                            Column(
                                children: [
                                  const Text("ATK", style: TextStyle(
                                      backgroundColor: Colors.red)),
                                  Text("${game.user2.attackScore}"),
                                ]
                            ),
                            Column(
                                children: [
                                  const Text("DEF", style: TextStyle(
                                      backgroundColor: Colors.blue)),
                                  Text("${game.user2.defenseScore}"),
                                ]
                            ),
                            Column(
                                children: [
                                  const Text("MP", style: TextStyle(
                                      backgroundColor: Colors
                                          .yellow)),
                                  Text("${game.user2.magicScore}"),
                                ]
                            ),
                          ]
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                          children: [
                            for (int i = 1; i <= 5; i++)
                              i > 5 - game.user2hp ? Expanded(
                                child: Container(
                                    height: 15.0,
                                    decoration: BoxDecoration(
                                      color: colors[game.user2hp - 1],
                                      border: Border.all(
                                          color: Colors.black,
                                          width: 0.0),
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: Image.asset(profilePictures[game.user2.pfp], width: 60, height: 60),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (whatUser1Did != "" && whatUser2Did != "")...[
                              Image.asset(whatUser1Did, width: 30, height: 30, color: moveColor(whatUser1Did)),
                              Image.asset(whatUser2Did, width: 30, height: 30, color: moveColor(whatUser2Did)),
                            ]
                            else...[
                              const SizedBox(
                                height: 30,
                              ),
                            ]
                          ]
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(pi),
                          child: Image.asset(profilePictures[game.user1.pfp], width: 60, height: 60),
                        ),
                      ),
                      Row(
                          children: [
                            const Text("HP"),
                            const SizedBox(
                              width: 5,
                            ),
                            for (int i = 1; i <= 5; i++)
                              i <= game.user1hp ? Expanded(
                                child: Container(
                                    height: 15.0,
                                    decoration: BoxDecoration(
                                      color: colors[game.user1hp - 1],
                                      border: Border.all(
                                          color: Colors.black,
                                          width: 0.0),
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
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  game.user1move == Move.none ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              game.user1move = Move.attack;
                            });
                          },
                          backgroundColor: Colors.red,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Attack'),
                                Text("${game.user1.attackScore}"),
                              ]
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              game.user1move = Move.defense;
                            });
                          },
                          backgroundColor: Colors.blue,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .center,
                              children: [
                                const Text('Defense'),
                                Text("${game.user1.defenseScore}"),
                              ]
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              game.user1move = Move.magic;
                            });
                          },
                          backgroundColor: Colors.yellow,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .center,
                              children: [
                                const Text('Magic'),
                                Text("${game.user1.magicScore}"),
                              ]
                          ),
                        ),
                      ]
                  ) :
                  const Text("Waiting on opponent"),
                ],
              );
            },
          )
  );
}
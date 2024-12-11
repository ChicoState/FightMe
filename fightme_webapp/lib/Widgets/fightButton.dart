
import 'package:fightme_webapp/Cosmetics/profile_pictures.dart';
import 'package:fightme_webapp/Models/httpservice.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fightme_webapp/Models/friend_request.dart';
import 'package:fightme_webapp/globals.dart' as globals;
import 'package:fightme_webapp/Models/fight_game_session.dart';

List<Move> randomMove = [Move.attack, Move.defense, Move.magic];

Color moveColor(Move move) {
  if (move == Move.attack) {
    return Colors.red;
  }
  else if (move == Move.defense) {
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

Future<void> buildFightButton(BuildContext context, FightGameSession game) async {
  if (globals.uid != game.user1.id && globals.uid != game.user2.id) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
            title: const Text(
                "There was an error."),
            content: const Text(
              "You are not a part of this game."
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
    );
  }
  final random = Random();
  List<Color> colors = [Colors.red, Colors.orangeAccent, Colors.amberAccent, Colors.yellowAccent[100]!, Colors.lightGreenAccent[400]!/*Why in God's name would this be Color? ?*/];
  showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(
            builder: (context, setState) {
              if (game.user1moves.last != Move.none) {
                if (game.user2.id == 0) {
                  game.user2moves.last = randomMove[random.nextInt(randomMove.length)];
                }
                if (game.user2moves.last != Move.none) {
                  if (game.id != 0) {
                    HttpService().setNewTurn(game).then((result) {
                      setState(() {
                        if (doesUserHit(
                            game.user1moves.last, game.user2moves.last)) {
                          game.user2hp--;
                        }
                        if (doesUserHit(
                            game.user2moves.last, game.user1moves.last)) {
                          game.user1hp--;
                        }
                        game.user1moves.add(Move.none);
                        game.user2moves.add(Move.none);
                      });
                      return;
                    });
                  }
                  else {
                    if (doesUserHit(
                        game.user1moves.last, game.user2moves.last)) {
                      game.user2hp--;
                    }
                    if (doesUserHit(
                        game.user2moves.last, game.user1moves.last)) {
                      game.user1hp--;
                    }
                    game.user1moves.add(Move.none);
                    game.user2moves.add(Move.none);
                  }
                }
              }
              if (game.user1hp == 0 || game.user2hp == 0) {
                if (game.id != 0) {
                  HttpService().declareWinner(game.id).then((
                      result) { //this could be an issue because of the curUser id
                    return;
                  });
                }
                return AlertDialog(
                    title: Text(endMessage(game.getUserHp(globals.uid), game.getOtherUserHp(globals.uid))),
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
                      Text("Turn ${game.user1moves.length}"),
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
                      Text(game.getOtherUser(globals.uid).name,
                          style: const TextStyle(fontSize: 20)),
                      Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceEvenly,
                          children: [
                            Column(
                                children: [
                                  const Text("ATK", style: TextStyle(
                                      backgroundColor: Colors.red)),
                                  Text("${game.getOtherUser(globals.uid).attackScore}"),
                                ]
                            ),
                            Column(
                                children: [
                                  const Text("DEF", style: TextStyle(
                                      backgroundColor: Colors.blue)),
                                  Text("${game.getOtherUser(globals.uid).defenseScore}"),
                                ]
                            ),
                            Column(
                                children: [
                                  const Text("MP", style: TextStyle(
                                      backgroundColor: Colors
                                          .yellow)),
                                  Text("${game.getOtherUser(globals.uid).magicScore}"),
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
                              i > 5 - game.getOtherUserHp(globals.uid) ? Expanded(
                                child: Container(
                                    height: 15.0,
                                    decoration: BoxDecoration(
                                      color: colors[game.getOtherUserHp(globals.uid) - 1],
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
                        child: Image.asset(profilePictures[game.getOtherUser(globals.uid).pfp], width: 60, height: 60),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (game.user1moves.length > 1  && game.user2moves.length > 1)...[
                              Image.asset(move(game.getUserMoves(globals.uid).elementAt(game.getUserMoves(globals.uid).length - 2)),
                                  width: 30, height: 30,
                                  color: moveColor(game.getUserMoves(globals.uid).elementAt(game.getUserMoves(globals.uid).length - 2))),
                              Image.asset(move(game.getOtherUserMoves(globals.uid).elementAt(game.getOtherUserMoves(globals.uid).length - 2)),
                                  width: 30, height: 30,
                                  color: moveColor(game.getOtherUserMoves(globals.uid).elementAt(game.getOtherUserMoves(globals.uid).length - 2))),
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
                          child: Image.asset(profilePictures[globals.curUser.pfp], width: 60, height: 60),
                        ),
                      ),
                      Row(
                          children: [
                            const Text("HP"),
                            const SizedBox(
                              width: 5,
                            ),
                            for (int i = 1; i <= 5; i++)
                              i <= game.getUserHp(globals.uid) ? Expanded(
                                child: Container(
                                    height: 15.0,
                                    decoration: BoxDecoration(
                                      color: colors[game.getUserHp(globals.uid) - 1],
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
                  game.getUserMoves(globals.uid).last == Move.none ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FloatingActionButton(
                          onPressed: () async {
                            if (game.id != 0) {
                              await HttpService().setMove(
                                  game.id, globals.uid, Move.attack);
                            }
                            setState(() {
                              game.getUserMoves(globals.uid).last = Move.attack;
                            });
                          },
                          backgroundColor: Colors.red,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Attack'),
                                Text("${globals.curUser.attackScore}"),
                              ]
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () async {
                            if (game.id != 0) {
                              await HttpService().setMove(
                                  game.id, globals.uid, Move.defense);
                            }
                            setState(() {
                              game.getUserMoves(globals.uid).last = Move.defense;
                            });
                          },
                          backgroundColor: Colors.blue,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .center,
                              children: [
                                const Text('Defense'),
                                Text("${globals.curUser.defenseScore}"),
                              ]
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () async {
                            if (game.id != 0) {
                              await HttpService().setMove(
                                  game.id, globals.uid, Move.magic);
                            }
                            setState(() {
                              game.getUserMoves(globals.uid).last = Move.magic;
                            });
                          },
                          backgroundColor: Colors.yellow,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .center,
                              children: [
                                const Text('Magic'),
                                Text("${globals.curUser.magicScore}"),
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
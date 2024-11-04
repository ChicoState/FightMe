import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fightme_webapp/Models/user.dart';

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
  return FloatingActionButton(
      onPressed: () =>
          showDialog<String>(
            context: context,
            builder: (BuildContext context) =>
                AlertDialog(
                  title: const Text('Fight!'),
                  content: SizedBox(
                    height: 100,
                    child: Column(
                        children: [
                          Text(user1.name, textAlign: TextAlign.left),
                          const Text('VS'),
                          Text(user2.name, textAlign: TextAlign.left),
                          Text(
                            "${doesUserWin(user1, user2) ? user1.name : user2
                                .name} wins!",
                            style: Theme
                                .of(context)
                                .textTheme
                                .headlineMedium,
                          ),
                        ]
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
          ),
      tooltip: 'Fight!',
      child: const Text('Fight!')
  );
}
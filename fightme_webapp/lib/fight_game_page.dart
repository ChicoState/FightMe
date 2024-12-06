// import 'dart:async';

// import 'package:fightme_webapp/Models/httpservice.dart';
// import 'package:fightme_webapp/game/FightGame.dart';
// import 'package:fightme_webapp/Providers/stats_provider.dart';
// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'globals.dart' as globals;

// class FightGamePage extends StatefulWidget {
//   final String pfp;
//   final String matchID;
//   final WebSocketChannel channel;
//   final Stream broadcastStream;

//   const FightGamePage({
//     Key? key,
//     required this.pfp,
//     required this.matchID,
//     required this.channel,
//     required this.broadcastStream,
//   }) : super(key: key);

//   @override
//   _FightGamePageState createState() => _FightGamePageState();
// }

// class _FightGamePageState extends State<FightGamePage> {
//   late StreamSubscription fightStreamSubscription;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     fightStreamSubscription.cancel();  // Cancel the subscription when leaving the page
//     widget.channel.sink.close();  // Close the WebSocket connection when done
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Fight Game - Match ID: ${widget.matchID}")),
//       body: GameWidget(game: FightGame(pfp: widget.pfp, matchID: widget.matchID, channel: widget.channel, broadcastStream: widget.broadcastStream)),
//     );
//   }
// }


import 'dart:async';

import 'package:fightme_webapp/Models/httpservice.dart';
import 'package:fightme_webapp/game/FightGame.dart';
import 'package:fightme_webapp/Providers/stats_provider.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'globals.dart' as globals;

class FightGamePage extends StatefulWidget {
  final String pfp;
  final String matchID;
  final WebSocketChannel channel;
  final Stream broadcastStream;

  const FightGamePage({
    Key? key,
    required this.pfp,
    required this.matchID,
    required this.channel,
    required this.broadcastStream,
  }) : super(key: key);

  @override
  _FightGamePageState createState() => _FightGamePageState();
}

class _FightGamePageState extends State<FightGamePage> {
  late StreamSubscription fightStreamSubscription;
  late FightGame fightGame;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // fightStreamSubscription.cancel();
    // widget.channel.sink.close();
    super.dispose();
  }

   void _onGameEnd() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void _showGameEndDialog(Map<String, int> stats) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Your Stats:'),
              Text('Attack Score: ${stats['attackScore']}'),
              Text('Magic Score: ${stats['magicScore']}'),
              Text('Defense Score: ${stats['defenseScore']}'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Return to Lobby'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Exit game page
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    fightGame = FightGame(
      pfp: widget.pfp, 
      matchID: widget.matchID, 
      channel: widget.channel, 
      broadcastStream: widget.broadcastStream,
      onGameEnd: _onGameEnd,
    );

    return Scaffold(
      appBar: AppBar(title: Text("Fight Game - Match ID: ${widget.matchID}")),
      body: GameWidget(
        game: fightGame,
        overlayBuilderMap: {
          'gameEndDialog': (BuildContext context, FightGame game) {
            return Container(); // Placeholder, not used directly
          }
        },
      ),
    );
  }
}
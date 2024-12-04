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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    fightStreamSubscription.cancel();  // Cancel the subscription when leaving the page
    widget.channel.sink.close();  // Close the WebSocket connection when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fight Game - Match ID: ${widget.matchID}")),
      body: GameWidget(game: FightGame(pfp: widget.pfp, matchID: widget.matchID, channel: widget.channel, broadcastStream: widget.broadcastStream)),
    );
  }
}


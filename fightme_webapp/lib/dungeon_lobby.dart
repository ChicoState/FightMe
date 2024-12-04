import 'dart:async';

import 'package:fightme_webapp/Providers/settings_provider.dart';
import 'package:fightme_webapp/fight_game_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class DungeonLobby extends StatefulWidget {
  const DungeonLobby({super.key});

  @override
  State<DungeonLobby> createState() => _DungeonLobbyState();
}

class _DungeonLobbyState extends State<DungeonLobby> {
  late WebSocketChannel channel;
  late StreamSubscription streamSubscription; 
  String statusMessage = '';

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:8080/ws/matchmaking'),
    );
    final broadcastStream = channel.stream.asBroadcastStream();

    // Start listening for messages from WebSocket
    streamSubscription = broadcastStream.listen((message) {
      setState(() {
        statusMessage = message;
        String matchID = message.split(':').last;
        final SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
        String pfp = settingsProvider.profilePicture.split('/').last;
        if (pfp.isEmpty) {
          pfp = 'default-avatar.png';
        }

        // When match is found, stop listening and navigate to FightGamePage
        if (statusMessage.contains("Match Found")) {
          streamSubscription.cancel();  // Stop listening for further messages

          Navigator.push(
            context,
            MaterialPageRoute<FightGamePage>(
                builder: (context) => FightGamePage(
                  pfp: pfp,
                  matchID: matchID,
                  channel: channel,
                  broadcastStream: broadcastStream,
                ),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    streamSubscription.cancel(); // Cancel subscription to avoid memory leaks
    channel.sink.close(); // Close the WebSocket connection
    super.dispose();
  }

  void findMatch() {
    try {
      channel.sink.add('Find Match');  // Send a request to find a match
      setState(() {
        statusMessage = "Searching for a match...";  // Update status message
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Dungeon Lobby'),
            ElevatedButton(
              onPressed: () {
                findMatch();  // Trigger match search
              },
              child: const Text('Find Match'),
            ),
            Text("$statusMessage"),  // Display status message
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);  // Go back to the previous page
              },
              child: const Text('Back out'),
            ),
          ],
        ),
      ),
    );
  }
}

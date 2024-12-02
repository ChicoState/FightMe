import 'package:fightme_webapp/Models/httpservice.dart';
import 'package:fightme_webapp/game/FightGame.dart';
import 'package:fightme_webapp/Providers/stats_provider.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'globals.dart' as globals;

class FightGamePage extends StatefulWidget {
  const FightGamePage({super.key});

  @override
  State<FightGamePage> createState() => FightGamePageState();
}

class FightGamePageState extends State<FightGamePage> {
  late final FightGame _fightGame;
  final HttpService _httpService = HttpService();
  Map<String, int> currentStats = {
    'attackScore': 0,
    'magicScore': 0,
    'defenseScore': 0,
  };


  @override
  void initState() {
    super.initState();
    _fightGame = FightGame();
    _loadUserStats();
  }

  Future<void> _loadUserStats() async {
    try {
      final user = await _httpService.getUserByID(globals.uid);
      setState(() {
        currentStats = {
          'attackScore': user.attackScore,
          'magicScore': user.magicScore,
          'defenseScore': user.defenseScore,
        };
      });
    } catch (e) {
      print('Error loading user stats: $e');
    }
  }

  void _handleSave() {
    Map<String, int> stats = _fightGame.saveStats();
    
    Map<String, int> combinedStats = {
      'attackScore': (currentStats['attackScore'] ?? 0) + (stats['attackScore'] ?? 0),
      'magicScore': (currentStats['magicScore'] ?? 0) + (stats['magicScore'] ?? 0),
      'defenseScore': (currentStats['defenseScore'] ?? 0) + (stats['defenseScore'] ?? 0),
    };

    final statsProvider = Provider.of<StatsProvider>(context, listen: false);


    // Show a dialog with the current stats
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Stats'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Attack: ${stats['attackScore']}'),
              Text('Magic: ${stats['magicScore']}'),
              Text('Defense: ${stats['defenseScore']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSaveConfirmation();
                HttpService().updateUserStats(globals.uid, combinedStats);
                statsProvider.updateStats(combinedStats['attackScore']!, combinedStats['magicScore']!, combinedStats['defenseScore']!);
                print("stats saved ${combinedStats['attackScore']} , ${combinedStats['magicScore']} , ${combinedStats['defenseScore']}");
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showSaveConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Stats saved successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fight Game"),
        backgroundColor: Theme
              .of(context)
              .colorScheme
              .primary,
          centerTitle: true,
        leading: IconButton(
          onPressed: _handleSave,
          icon: const Icon(Icons.save),
          tooltip: 'Save Stats',
        ),
      ),
      body: GameWidget(
        game: _fightGame,
      ),
    );
  }
}
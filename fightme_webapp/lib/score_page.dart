import 'package:flutter/material.dart';
import 'Models/httpservice.dart';

class ScorePage extends StatefulWidget {
  final int userId;

  const ScorePage(
    {super.key, required this.userId}
  );
  @override
  State<ScorePage> createState() => ScorePageState();
}


class ScorePageState extends State<ScorePage> {
  int attackScore = 0;
  int defenseScore = 0;
  int magicScore = 0;


  void updateScores() async {
    await HttpService().updateUserStats(widget.userId, attackScore, defenseScore, magicScore);
  }


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Score Page')),
      backgroundColor: Colors.blueGrey[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Column(
            children: [
              Text('Attack Score: $attackScore'),
              const SizedBox(height: 10),
              Text('Defense Score: $defenseScore'),
              const SizedBox(height: 10),
              Text('Magic Score: $magicScore'),
            ],
          ),
          
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      attackScore += 1;
                    });
                    updateScores();
                  },
                  child: const Text('Increase Attack'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      defenseScore += 1;
                    });
                    updateScores();
                  },
                  child: const Text('Increase Defense'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      magicScore += 1;
                    });
                    updateScores();
                  },
                  child: const Text('Increase Magic'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

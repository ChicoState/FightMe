import 'package:flutter/material.dart';

class ScorePage extends StatefulWidget {

  const ScorePage(
    {super.key}
  );
  @override
  State<ScorePage> createState() => ScorePageState();
}

class ScorePageState extends State<ScorePage> {
  int attackScore = 0;
  int defenseScore = 0;
  int magicScore = 0;

  void incrementScore(String scoreType) {
    setState(() {
      if (scoreType == "attack"){ 
        attackScore += 1;
      }
      else if (scoreType == "defense"){
         defenseScore += 1;
      }
      else if (scoreType == "magic"){
        magicScore += 1;
      }
    });
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Score Page')),
      backgroundColor: Colors.blueGrey[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Score Displays at the Top
          Column(
            children: [
              Text('Attack Score: $attackScore', style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Text('Defense Score: $defenseScore', style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Text('Magic Score: $magicScore', style: const TextStyle(fontSize: 20)),
            ],
          ),
          
          // Score Increment Buttons at the Bottom
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => incrementScore("attack"),
                  child: const Text('Increase Attack'),
                ),
                ElevatedButton(
                  onPressed: () => incrementScore("defense"),
                  child: const Text('Increase Defense'),
                ),
                ElevatedButton(
                  onPressed: () => incrementScore("magic"),
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

import 'package:fightme_webapp/Models/user.dart';
import 'package:fightme_webapp/main.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'Models/httpservice.dart';

class GamerscoreShop extends StatefulWidget {
  final User curUser;
  const GamerscoreShop({super.key, required this.curUser});

  @override
  State<GamerscoreShop> createState() => _GamerscoreShopState();
}

class _GamerscoreShopState extends State<GamerscoreShop> {
  final HttpService _httpService = HttpService();
  Map<String, int> currentStats = {
    'attackScore': curUser.attackScore,
    'magicScore': curUser.magicScore,
    'defenseScore': curUser.defenseScore,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop"),
        backgroundColor: Theme
              .of(context)
              .colorScheme
              .primary,
          centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monetization_on, color: Colors.yellow, size: 30,),
                Text("GamerScore: ${widget.curUser.gamerScore}", style: const TextStyle(fontSize: 20),),
                const Icon(Icons.monetization_on, color: Colors.yellow, size: 30,),
              ],
            ),
            const SizedBox(
              height: 200,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Image.asset("assets/images/attack.png", height: 80, width: 80, color: Colors.red),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3 - 60.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          if(curUser.gamerScore < 1) {
                            return;
                          }
                          await _httpService.updateUserGamerScore(globals.uid, curUser.gamerScore - 1);
                          currentStats['attackScore'] = curUser.attackScore + 1;
                          await _httpService.updateUserStats(globals.uid,currentStats);
                          setState(() {
                            curUser.attackScore = curUser.attackScore + 1;
                            curUser.gamerScore = curUser.gamerScore - 1;
                          });
                        },
                        child: const Text("Buy Attack"),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Image.asset("assets/images/defense.png", height: 80, width: 80, color: Colors.green,),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3 - 60.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          if(curUser.gamerScore < 1) {
                            return;
                          }
                          await _httpService.updateUserGamerScore(globals.uid, curUser.gamerScore - 1);
                          currentStats['defenseScore'] = curUser.defenseScore + 1;
                          await _httpService.updateUserStats(globals.uid,currentStats);
                          setState(() {
                            curUser.defenseScore = curUser.defenseScore + 1;
                            curUser.gamerScore = curUser.gamerScore - 1;
                          });
                        },
                        child: const Text("Buy Defense"),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Image.asset("assets/images/magic.png", width: 80, height: 80, color: Colors.purple,),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3 - 60.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          if(curUser.gamerScore < 1) {
                            return;
                          }
                          await _httpService.updateUserGamerScore(globals.uid, curUser.gamerScore - 1);
                          currentStats['magicScore'] = curUser.magicScore + 1;
                          await _httpService.updateUserStats(globals.uid,currentStats);
                          setState(() {
                            curUser.magicScore = curUser.magicScore + 1;
                            curUser.gamerScore = curUser.gamerScore - 1;
                          });
                        },
                        child: const Text("Buy Magic"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
      ),
    )
    );
  }
}
import 'package:fightme_webapp/Models/user.dart';
import 'package:fightme_webapp/main.dart';
import 'package:flutter/material.dart';
import 'Cosmetics/profile_pictures.dart';
import 'Cosmetics/themes.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,
        centerTitle: true,
        title: const Text("Shop"),
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
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Profile Pictures", style: TextStyle(
                fontSize: 40)),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.25,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                  shrinkWrap: true,
                itemCount: buyableProfilePictures.length,
                itemBuilder: (BuildContext context, int index) {
                  bool bought = widget.curUser.unlockedpfps.firstWhere((element) => element == buyableProfilePictures[index][0], orElse: () => -1) != -1;
                  return TextButton(
                    onPressed: () {
                      if (!bought) {
                        if (buyableProfilePictures[index][1] > widget.curUser.gamerScore) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text('You do not have enough gamer score for that.'),
                              )
                          );
                        }
                        else {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                AlertDialog(
                                  title: const Text(
                                      'Are you sure you want to buy?'),
                                  content: Image.asset(
                                      profilePictures[buyableProfilePictures[index][0]],
                                      width: 150, height: 150),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'No'),
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await _httpService.updateUserGamerScore(globals.uid, widget.curUser.gamerScore - buyableProfilePictures[index][1]);
                                        await _httpService.addUserProfilePicture(globals.uid, buyableProfilePictures[index][0]);
                                        setState(() {
                                          widget.curUser.unlockedpfps.add(buyableProfilePictures[index][0]);
                                          widget.curUser.gamerScore = widget.curUser.gamerScore - buyableProfilePictures[index][1];
                                        });
                                        Navigator.pop(context, 'Yes');
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                ),
                          );
                        }
                      }
                    },
                    child: GridTile(
                      child: Column(
                          children: [
                            Image.asset(profilePictures[buyableProfilePictures[index][0]], width: 200, height: 200),
                            bought ? const Text("Bought", style: TextStyle(
                                fontSize: 30)) :
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("${buyableProfilePictures[index][1]}", style: const TextStyle(
                                      fontSize: 30)),
                                  const Icon(Icons.monetization_on, color: Colors.yellow, size: 30,),
                                ]
                            ),
                          ]
                      ),
                    ),
                  );
                }
            ),
      ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Themes", style: TextStyle(
                  fontSize: 40)),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 3.0,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.25,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  shrinkWrap: true,
                  itemCount: buyableThemes.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool bought = widget.curUser.unlockedThemes.firstWhere((element) => element == buyableThemes[index][0], orElse: () => -1) != -1;
                    return TextButton(
                      onPressed: () {
                        if (!bought) {
                          if (buyableThemes[index][1] > widget.curUser.gamerScore) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(seconds: 3),
                                  content: Text('You do not have enough gamer score for that.'),
                                )
                            );
                          }
                          else {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  AlertDialog(
                                    title: const Text(
                                        'Are you sure you want to buy?'),
                                    content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                              height: 45.0,
                                              decoration: BoxDecoration(
                                                color: themes[buyableThemes[index][0]].primary,
                                              )
                                          ),
                                          Container(
                                              height: 90.0,
                                              decoration: BoxDecoration(
                                                color: themes[buyableThemes[index][0]].surface,
                                              ),
                                              child: Align(
                                                child: Text(themeNames[buyableThemes[index][0]], style: TextStyle(
                                                    color: themes[buyableThemes[index][0]].onSurface)),
                                              )
                                          ),
                                          Container(
                                              height: 45.0,
                                              decoration: BoxDecoration(
                                                color: themes[buyableThemes[index][0]].secondary,
                                              )
                                          ),
                                        ]
                                    ),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'No'),
                                        child: const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await _httpService.updateUserGamerScore(globals.uid, widget.curUser.gamerScore - buyableThemes[index][1]);
                                          await _httpService.addUserTheme(globals.uid, buyableThemes[index][0]);
                                          setState(() {
                                            widget.curUser.unlockedThemes.add(buyableThemes[index][0]);
                                            widget.curUser.gamerScore = widget.curUser.gamerScore - buyableThemes[index][1];
                                          });
                                          Navigator.pop(context, 'Yes');
                                        },
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  ),
                            );
                          }
                        }
                      },
                      child: GridTile(
                          child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: themes[buyableThemes[index][0]].primary,
                                      )
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: themes[buyableThemes[index][0]].surface,
                                    ),
                                    child: Align(
                                    child: Text(themeNames[buyableThemes[index][0]], style: TextStyle(
                                        color: themes[buyableThemes[index][0]].onSurface)),
                                    )
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: themes[buyableThemes[index][0]].secondary,
                                      )
                                  ),
                                ),
                                bought ? const Text("Bought", style: TextStyle(
                                    fontSize: 30)) :
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${buyableProfilePictures[index][1]}", style: const TextStyle(
                                          fontSize: 30)),
                                      const Icon(Icons.monetization_on, color: Colors.yellow, size: 30,),
                                    ]
                                ),
                              ]
                          )
                      ),
                    );
                  }
              ),
            ),
          ],
      ),
    )
    );
  }
}
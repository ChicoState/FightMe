import 'package:flutter/material.dart';
import 'Models/fight_game_session.dart';
import 'Models/user.dart';
import 'package:fightme_webapp/Models/httpservice.dart';
import 'Widgets/fightButton.dart';
import 'Cosmetics/profile_pictures.dart';
import 'globals.dart' as globals;

class VsPage extends StatefulWidget {

  const VsPage({super.key});

  @override
  State<VsPage> createState() => VsPageState();
}


class VsPageState extends State<VsPage> {
  late Future<List<Widget>> _list = Future.value([]);

  Future<List<Widget>> _buildList() async {
    List<Color> colors = [Colors.red, Colors.orangeAccent, Colors.amberAccent, Colors.yellowAccent[100]!, Colors.lightGreenAccent[400]!];
    HttpService http = HttpService();
    List<Widget> list = List.empty(growable: true);
    List<FightGameSession> myFights = await http.getActiveGames(globals.uid);
    for (var fight in myFights) {
      User user = fight.getOtherUser(globals.uid);
      list.add(
          TextButton(
              onPressed: () {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) =>
                    FightButton(game: fight)
                );
              },
              child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: Image.asset(profilePictures[user.pfp], fit: BoxFit.cover, width: 60, height: 60),
                  ),
                  title: user.id != 0 ? Text(user.name) : const Text("Group"),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                          children: [
                            const Visibility(
                              maintainSize: true,
                              visible: false,
                              maintainAnimation: true,
                              maintainState: true,
                              child: Text("HP"),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            for (int i = 1; i <= 5; i++)
                              i > 5 - fight.getOtherUserHp(globals.uid) ? Expanded(
                                child: Container(
                                    height: 15.0,
                                    decoration: BoxDecoration(
                                      color: colors[fight.getOtherUserHp(globals.uid) - 1],
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
                      Row(
                          children: [
                            const Text("HP"),
                            const SizedBox(
                              width: 5,
                            ),
                            for (int i = 1; i <= 5; i++)
                              i <= fight.getUserHp(globals.uid) ? Expanded(
                                child: Container(
                                    height: 15.0,
                                    decoration: BoxDecoration(
                                      color: colors[fight.getUserHp(globals.uid) - 1],
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
                            const Visibility(
                              maintainSize: true,
                              visible: false,
                              maintainAnimation: true,
                              maintainState: true,
                              child: Text("HP"),
                            ),
                          ]
                      ),
                    ],
                  ),
              )
          )
      );
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    _list = _buildList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,
        centerTitle: true,
        title: const Text("Active Games"),
      ),
      body: Center(
        child: Column(
          children: [
            FutureBuilder(future: _list, builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const Text(
                      "No chat rooms available. Go and make some friends.");
                }
                else {
                  return ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: snapshot.data!
                  );
                }
              }
              else {
                return const CircularProgressIndicator();
              }
            }),
          ],
        ),
      ),
    );
  }
}
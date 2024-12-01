import 'package:flutter/material.dart';
import 'Models/fight_game_session.dart';
import 'Models/user.dart';
import 'package:fightme_webapp/Models/httpservice.dart';
import 'Widgets/fightButton.dart';
import 'Cosmetics/profile_pictures.dart';
import 'globals.dart' as globals;

class VsPage extends StatefulWidget {
  final User curUser;

  const VsPage({super.key, required this.curUser});

  @override
  State<VsPage> createState() => VsPageState();
}


class VsPageState extends State<VsPage> {
  late Future<List<Widget>> _list = Future.value([]);

  Future<List<Widget>> _buildList() async {
    List<Color> colors = [Colors.red, Colors.orangeAccent, Colors.amberAccent, Colors.yellowAccent[100]!, Colors.lightGreenAccent[400]!];
    HttpService http = HttpService();
    List<Widget> list = List.empty(growable: true);
    List<FightGameSession> myFights = List.empty(growable: true); // TODO: Write the fighting game session in the backend then write a function in HttpService.
    myFights.removeWhere((element) => element.winnerID != 0);
    for (var fight in myFights) {
      User user = fight.user2;
      list.add(
          TextButton(
              onPressed: () {
                buildFightButton(context, fight);
              },
              child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: Image.asset(profilePictures[user.pfp], fit: BoxFit.cover, width: 60, height: 60),
                  ),
                  title: user.id != 0 ? Text(user.name) : const Text("Group"),
                  trailing: Column(
                    children: [
                      Row(
                          children: [
                            for (int i = 1; i <= 5; i++)
                              i > 5 - fight.user2hp ? Expanded(
                                child: Container(
                                    height: 15.0,
                                    decoration: BoxDecoration(
                                      color: colors[fight.user2hp - 1],
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
                              i <= fight.user1hp ? Expanded(
                                child: Container(
                                    height: 15.0,
                                    decoration: BoxDecoration(
                                      color: colors[fight.user1hp - 1],
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
        title: const Text("Home"),
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
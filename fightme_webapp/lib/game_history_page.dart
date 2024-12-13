import 'package:flutter/material.dart';
import 'Models/fight_game_session.dart';
import 'Models/user.dart';
import 'package:fightme_webapp/Models/httpservice.dart';
import 'Widgets/fightButton.dart';
import 'Cosmetics/profile_pictures.dart';
import 'globals.dart' as globals;

class GameHistoryPage extends StatefulWidget {

  const GameHistoryPage({super.key});

  @override
  State<GameHistoryPage> createState() => GameHistoryPageState();
}


class GameHistoryPageState extends State<GameHistoryPage> {
  late Future<List<Widget>> _list = Future.value([]);

  Future<List<Widget>> _buildList() async {
    HttpService http = HttpService();
    List<Widget> list = List.empty(growable: true);
    List<FightGameSession> myFights = await http.getDoneGames(globals.uid);
    for (var fight in myFights) {
      User user = fight.getOtherUser(globals.uid);
      list.add(
          TextButton(
              onPressed: () {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => FightButton(game: fight)
                );
              },
              child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: Image.asset(profilePictures[user.pfp], fit: BoxFit.cover, width: 60, height: 60),
                  ),
                  title: user.id != 0 ? Text(user.name) : const Text("Group"),
                tileColor: fight.winnerID == globals.uid ? Colors.green : Colors.red,
                  ),
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
        title: const Text("Previous games"),
      ),
      body: Center(
        child: Column(
          children: [
            FutureBuilder(future: _list, builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const Text(
                      "No games available. Go fight some people.");
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
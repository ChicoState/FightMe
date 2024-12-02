import 'package:flutter/material.dart';
import 'Models/chatroom.dart';
import 'Models/user.dart';
import 'package:fightme_webapp/Models/httpservice.dart';
import 'pending_requests.dart';
import 'globals.dart' as globals;

class LeaderboardPage extends StatefulWidget {
  final User curUser;

  const LeaderboardPage({super.key, required this.curUser});

  @override
  State<LeaderboardPage> createState() => LeaderboardPageState();
}


class LeaderboardPageState extends State<LeaderboardPage> {
  late Future<List<Widget>> _list = Future.value([]);

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
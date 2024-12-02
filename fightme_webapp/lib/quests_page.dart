import 'package:flutter/material.dart';
import 'Models/chatroom.dart';
import 'Models/user.dart';
import 'package:fightme_webapp/Models/httpservice.dart';
import 'pending_requests.dart';
import 'globals.dart' as globals;

class QuestsPage extends StatefulWidget {
  final User curUser;

  const QuestsPage({super.key, required this.curUser});

  @override
  State<QuestsPage> createState() => QuestsPageState();
}


class QuestsPageState extends State<QuestsPage> {
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
        // Suggestion for this segment: https://api.flutter.dev/flutter/material/TabBar-class.html
      ),
      body: Center(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
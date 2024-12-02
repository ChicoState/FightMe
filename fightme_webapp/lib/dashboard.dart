import 'package:flutter/material.dart';
import 'Models/chatroom.dart';
import 'Models/user.dart';
import 'package:fightme_webapp/Models/httpservice.dart';
import 'pending_requests.dart';
import 'globals.dart' as globals;

class DashboardPage extends StatefulWidget {
  final User curUser;

  const DashboardPage({super.key, required this.curUser});

  @override
  State<DashboardPage> createState() => DashboardPageState();
}


class DashboardPageState extends State<DashboardPage> {
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

          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import 'Models/user.dart';

class ProfilePage extends StatefulWidget {
  final User userViewed;
  final int currentUserId;
  // final List<int> currentUserFriends;
  const ProfilePage(
  {super.key,
  required this.userViewed, required this.currentUserId});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> friendsList = List<String>.filled(5, widget.userViewed.name);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fight Me"),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.userViewed.id == widget.currentUserId ?
                IconButton(
                  onPressed: () {

                  },
                  icon: const Icon(Icons.settings),
                ): const SizedBox.shrink(),
                Placeholder(
                  fallbackHeight: 100,
                  fallbackWidth: 100,
                  child: Image.network(
                      "https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6HQK0xQgDQEELoTuERO4SsWV.jpg"),
                ),
                widget.userViewed.id == widget.currentUserId ?
                IconButton(
                  onPressed: () {

                  },
                  icon: const Icon(Icons.logout),
                ): const SizedBox.shrink(),
              ],
            ),
            Text(widget.userViewed.name, style: Theme
                .of(context)
                .textTheme
                .headlineMedium),
          if (widget.userViewed.id != widget.currentUserId)...[
            FilledButton.tonal(
              onPressed: () {

              },
              child: const Text("add Friend"),
            )
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text("Attack", style: TextStyle(
                        fontSize: 40)),
                    Text("${widget.userViewed.gamerScore}", style: Theme
                        .of(context)
                        .textTheme
                        .headlineMedium),
                  ],
                ),
                Column(
                  children: [
                    const Text("Defense", style: TextStyle(
                        fontSize: 40)),
                    Text("${widget.userViewed.gamerScore}", style: Theme
                        .of(context)
                        .textTheme
                        .headlineMedium),
                  ],
                ),
                Column(
                  children: [
                    const Text("Magic", style: TextStyle(
                      fontSize: 40)),
                    Text("${widget.userViewed.gamerScore}", style: Theme
                        .of(context)
                        .textTheme
                        .headlineMedium),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text("Friends"),
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width / 2 - 60.0,
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.symmetric(horizontal:  30.0),
                      decoration: BoxDecoration(border: Border.all()),
                      child: listView(friendsList),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text("Friends"),
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width / 2 - 60.0,
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.symmetric(horizontal:  30.0),
                      decoration: BoxDecoration(border: Border.all()),
                      child: listView(friendsList),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

listView(list) => ListView.builder(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemCount: list.length,
    itemBuilder: (context, index) {
      return Column(children: <Widget>[
        ListTile(
          title: Text(list[index]),
        )
      ]);
    }
);
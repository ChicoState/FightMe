import 'package:fightme_webapp/gamerscore_shop.dart';
import 'package:flutter/material.dart';
import 'Models/user.dart';
import 'Widgets/friend_request_button.dart';
import 'Models/httpservice.dart';
import 'globals.dart' as globals;

class ProfilePage extends StatefulWidget {
  final User userViewed;
  final User curUser;
  const ProfilePage(
  {super.key,
  required this.userViewed, required this.curUser});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late Future<List<User>> _friends;

  void _update() {
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    _friends = HttpService().getFriends(widget.userViewed.id);
  }

  friendsListView(list) => ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Column(children: <Widget>[
          ListTile(
            leading: const Icon(Icons.account_circle_sharp),
            onTap: () =>
                Navigator.push(
                    context,
                    MaterialPageRoute<ProfilePage>(
                        builder: (context) => ProfilePage(
                            curUser: widget.curUser,
                            userViewed: list[index]))),
            title: Text(list[index].name),
          )
        ]);
      }
  );

  @override
  Widget build(BuildContext context) {
    List<String> friendsList = List<String>.filled(5, widget.userViewed.name);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Fight Me"),
        actions: [
          if (widget.userViewed.id == widget.curUser.id) ...[
            Text("${widget.userViewed.gamerScore}", style: const TextStyle(fontSize: 20),),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<GamerscoreShop>(
                      builder: (context) => GamerscoreShop(curUser: widget.userViewed)),
                );
              },
              icon: const Icon(Icons.monetization_on, color: Colors.yellow, size: 30,),
            ),
          ],
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.userViewed.id == widget.curUser.id ?
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
                widget.userViewed.id == widget.curUser.id ?
                IconButton(
                  onPressed: () =>
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) =>
                            AlertDialog(
                              title: const Text('Are you sure you want to log out?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    globals.uid == 0;
                                    // Navigator.pushNamedAndRemoveUntil(context, "/newRouteName", (r) => false);
                                  },
                                  child: const Text('logout'),
                                ),
                              ],
                            ),
                      ),
                  icon: const Icon(Icons.logout),
                ): const SizedBox.shrink(),
              ],
            ),
            Text(widget.userViewed.name, style: Theme
                .of(context)
                .textTheme
                .headlineMedium),
            if (widget.userViewed.id != widget.curUser.id)...[
              FutureBuilder(future: buildFriendButton(context, _update, widget.userViewed, widget.curUser), builder: (BuildContext context, AsyncSnapshot<Widget> wid) {
                if (wid.hasData) {
                  return wid.data!;
                }
                return const CircularProgressIndicator();
              }),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text("Attack", style: TextStyle(
                        fontSize: 40)),
                    Text("${widget.userViewed.attackScore}", style: Theme
                        .of(context)
                        .textTheme
                        .headlineMedium),
                  ],
                ),
                Column(
                  children: [
                    const Text("Defense", style: TextStyle(
                        fontSize: 40)),
                    Text("${widget.userViewed.defenseScore}", style: Theme
                        .of(context)
                        .textTheme
                        .headlineMedium),
                  ],
                ),
                Column(
                  children: [
                    const Text("Magic", style: TextStyle(
                      fontSize: 40)),
                    Text("${widget.userViewed.magicScore}", style: Theme
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
                      child:FutureBuilder(future: _friends, builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {
                            return const Text(
                                "No friends. Go make some!");
                          }
                          else {
                            return friendsListView(snapshot.data!);
                          }
                        }
                        else {
                          return const CircularProgressIndicator();
                        }
                      }),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text("Placeholder"),
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width / 2 - 60.0,
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.symmetric(horizontal:  30.0),
                      decoration: BoxDecoration(border: Border.all()),
                      child: const Text("What would you like to see here?", style: TextStyle(
                          fontSize: 40, )),
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
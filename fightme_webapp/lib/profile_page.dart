import 'package:fightme_webapp/gamerscore_shop.dart';
import 'package:fightme_webapp/home.dart';
import 'package:flutter/material.dart';
import 'Models/user.dart';
import 'Widgets/friend_request_button.dart';
import 'Models/httpservice.dart';
import 'Cosmetics/profile_pictures.dart';
import 'globals.dart' as globals;
import 'Models/auth_clear.dart';

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
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(60.0),
              child: Image.asset(profilePictures[list[index].pfp], fit: BoxFit.cover, width: 60, height: 60),
            ),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,
        centerTitle: true,
        title: const Text("Profile"),
        actions: [
          if (widget.userViewed.id == widget.curUser.id) ...[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<GamerscoreShop>(
                      builder: (context) => GamerscoreShop(curUser: widget.curUser)),
                );
              },
              icon: Row(
                  children: [
                    Text("${widget.userViewed.gamerScore}", style: const TextStyle(fontSize: 20),),
                    const Icon(Icons.monetization_on, color: Colors.yellow, size: 30,),
                  ]
              ),
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
                const SizedBox(
                  width: 40.0,
                ),
                Center(
                  child: Image.asset(profilePictures[widget.userViewed.pfp], width: 200, height: 200),
                ),
                SizedBox(
                  height: 200,
                  child: widget.userViewed.id == widget.curUser.id ?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {

                          },
                          icon: const Icon(Icons.settings, size: 40),
                        ),
                        IconButton(
                          onPressed: () =>
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    AlertDialog(
                                      title: const Text('Are you sure you want to log out?'),
                                      actionsAlignment: MainAxisAlignment.spaceBetween,
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await clearUserData();
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute<Home>(
                                                  builder: (context) => Home()),
                                                  (route) => false,
                                            );
                                          },
                                          child: const Text('logout'),
                                        ),
                                      ],
                                    ),
                              ),
                          icon: const Icon(Icons.logout, size: 40),
                        ),
                      ]
                  ) : Align(
                    alignment: Alignment.topCenter,
                    child: PopupMenuButton<String>(
                      initialValue: "",
                      // Callback that sets the selected popup menu item.
                      onSelected: (String item) {
                        setState(() {
                        });
                      },
                      iconSize: 40,
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'Remove',
                          child: Text('Remove'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Report',
                          child: Text('Report'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Favorite',
                          child: Text('Favorite'),
                        ),
                      ],
                    ),
                  ),
                ),
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
                      height: MediaQuery.of(context).size.height / 2.5,
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
                      height: MediaQuery.of(context).size.height / 2.5,
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
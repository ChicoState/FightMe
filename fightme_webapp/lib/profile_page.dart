import 'package:fightme_webapp/gamerscore_shop.dart';
import 'package:fightme_webapp/home.dart';
import 'package:fightme_webapp/settings_page.dart';
import 'package:fightme_webapp/Providers/stats_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pending_requests.dart';
import 'Models/user.dart';
import 'Widgets/friend_request_button.dart';
import 'Models/httpservice.dart';
import 'Models/fight_game_session.dart';
import 'game_history_page.dart';
import 'Cosmetics/profile_pictures.dart';
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
  late Future<List<FightGameSession>> _games;

  @override
  void initState() {
    super.initState();
    _friends = HttpService().getFriends(widget.userViewed.id);
    _games = HttpService().getDoneGames(widget.userViewed.id);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final statsProvider = Provider.of<StatsProvider>(context, listen: false);
      statsProvider.initializeStats(widget.userViewed);
    });
}

  int getWonGames(List<FightGameSession> games) {
    int count = 0;
    for (var game in games) {
      if (game.winnerID == widget.userViewed.id) {
        count++;
      }
    }
    return count;
  }

  double getGameRatio(List<FightGameSession> games) {
    int winCount = 0; // |  ||
    int lossCount = 0;// || |_
    for (var game in games) {
      if (game.winnerID == widget.userViewed.id) {
        winCount++;
      }
      else {
        lossCount++;
      }
    }
    if (lossCount == 0) {
      return winCount.toDouble();
    }
    else {
      return winCount / lossCount;
    }
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
              icon: Consumer<StatsProvider>(
                builder: (context, statsProvider, child) {
                return Row(
                    children: [
                      Text("${statsProvider.gamerscore}", style: const TextStyle(fontSize: 20),),
                      const Icon(Icons.monetization_on, color: Colors.yellow, size: 30,),
                    ]
                );
                },
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
                            Navigator.push(context, MaterialPageRoute<SettingsPage>(
                                builder: (context) => const SettingsPage()));
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
              FriendButton(curUser: widget.curUser, otherUser: widget.userViewed),
            ],
            Consumer<StatsProvider>(
                builder: (context, statsProvider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text("Attack", style: TextStyle(
                            fontSize: 40)),
                        Text("${statsProvider.attack}", style: Theme
                            .of(context)
                            .textTheme
                            .headlineMedium),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Defense", style: TextStyle(
                            fontSize: 40)),
                        Text("${statsProvider.defense}", style: Theme
                            .of(context)
                            .textTheme
                            .headlineMedium),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Magic", style: TextStyle(
                            fontSize: 40)),
                        Text("${statsProvider.magic}", style: Theme
                            .of(context)
                            .textTheme
                            .headlineMedium),
                      ],
                    ),
                  ],
                );
              }
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
                      child: FutureBuilder(future: _friends, builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
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
                FutureBuilder(future: _games, builder: (BuildContext context, AsyncSnapshot<List<FightGameSession>> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        const Text("Games won"),
                        Text("${getWonGames(snapshot.data!)}"),
                        const Text("Win/loss ratio"),
                        Text(getGameRatio(snapshot.data!).toStringAsFixed(2)),
                        if (widget.userViewed.id == widget.curUser.id) ...[
                          FilledButton.tonal(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<GameHistoryPage>(
                                      builder: (context) => const GameHistoryPage()));
                            },
                            child: const Text("Game history"),
                          ),
                          FilledButton.tonal(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<PendingRequestsPage>(
                                      builder: (context) => const PendingRequestsPage()));
                            },
                            child: const Text("Pending Requests"),
                          ),
                        ],
                      ],
                    );
                  }
                  else {
                    return const Column(
                      children: [
                        Text("Games won"),
                        CircularProgressIndicator(),
                        Text("Win/loss ratio"),
                        CircularProgressIndicator(),
                      ],
                    );
                  }
                }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
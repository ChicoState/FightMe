import 'package:flutter/material.dart';
import 'package:fightme_webapp/Models/httpservice.dart';
import 'profile_page.dart';
import 'Cosmetics/profile_pictures.dart';
import 'package:fightme_webapp/Models/user.dart';
import 'Widgets/fightButton.dart';
import 'package:fightme_webapp/Models/friend_request.dart';
import 'package:fightme_webapp/Models/fight_game_session.dart';
import 'globals.dart' as globals;

class PendingRequestsPage extends StatefulWidget {
  const PendingRequestsPage(
      {super.key});

  @override
  State<PendingRequestsPage> createState() => PendingRequestsPageState();
}


class PendingRequestsPageState extends State<PendingRequestsPage> {
  late Future<List<Widget>> _recvlist;
  late Future<List<Widget>> _sentlist;
  late User curUser;

  Future<List<Widget>> _buildReceivedList() async {
    HttpService http = HttpService();
    List<Widget> list = List.empty(growable: true);
    List<FriendRequest> myRequests = await http.getAllFriendRequests(globals.uid);
    myRequests.removeWhere((element) => element.status == Status.rejected);
    for (var request in myRequests) {
      FriendRequest otherRequest = await http.getFriendRequest(request.toUserID, request.fromUserID);
      if (otherRequest.isEmpty() || (otherRequest.id != 0 && otherRequest.status == Status.pending)) {
        User user = await http.getUserByID(request.fromUserID);
        FightGameSession game = await http.getFightGame(globals.uid, user.id);
        list.add(
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<ProfilePage>(
                          builder: (context) =>
                              ProfilePage(
                                  curUser: curUser,
                                  userViewed: user)));
                },
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: Image.asset(
                        profilePictures[user.pfp], fit: BoxFit.cover,
                        width: 60,
                        height: 60),
                  ),
                  title: user.id != 0 ? Text(user.name) : const Text("Group"),
                  trailing: request.status == Status.pending ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FilledButton.tonal(
                          onPressed: () {
                            http.acceptFriendRequest(request.id).then((result) {
                              return;
                            });
                            http.postFightGame(curUser, user, user.id).then((result){
                              return;
                            });
                            setState(() {
                              _recvlist = _buildReceivedList();
                            });
                          },
                          child: const Text("accept"),
                        ),
                        FilledButton.tonal(
                          onPressed: () {
                            http.rejectFriendRequest(request.id).then((result) {
                              return;
                            });
                            setState(() {
                              _recvlist = _buildReceivedList();
                            });
                          },
                          child: const Text("reject"),
                        )
                      ]
                  ) : FilledButton.tonal(
                      onPressed: () {
                        if (game.id != 0) {
                          FightButton(game: game);
                        }
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text('There was an error retrieving the request.'),
                              )
                          );
                        }
                      },
                      child: const Text('Fight!')
                  ),
                )
            )
        );
      }
    }
    return list;
  }

  Future<List<Widget>> _buildSentList() async {
    HttpService http = HttpService();
    List<Widget> list = List.empty(growable: true);
    List<FriendRequest> myRequests = await http.getAllSentRequests(globals.uid);
    myRequests.removeWhere((element) => element.status == Status.rejected);
    for (var request in myRequests) {
      FriendRequest otherRequest = await http.getFriendRequest(request.toUserID, request.fromUserID);
      if (otherRequest.isEmpty() || (otherRequest.id != 0 && otherRequest.status == Status.pending)) {
        User user = await http.getUserByID(request.toUserID);
        FightGameSession game = await http.getFightGame(globals.uid, user.id);
        list.add(
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<ProfilePage>(
                          builder: (context) =>
                              ProfilePage(
                                  curUser: curUser,
                                  userViewed: user)));
                },
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: Image.asset(
                        profilePictures[user.pfp], fit: BoxFit.cover,
                        width: 60,
                        height: 60),
                  ),
                  title: user.id != 0 ? Text(user.name) : const Text("Group"),
                  trailing: request.status == Status.pending ? const SizedBox.shrink()
                      : FilledButton.tonal(
                      onPressed: () {
                        if (game.id != 0) {
                          FightButton(game: game);
                        }
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text('There was an error retrieving the request.'),
                              )
                          );
                        }
                      },
                      child: const Text('Fight!')
                  ),
                )
            )
        );
      }
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    HttpService().getUserByID(globals.uid).then((result) {
      curUser =  result;
    });
    _recvlist = _buildReceivedList();
    _sentlist = _buildSentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Requests"),
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Received Requests", style: TextStyle(
                fontSize: 40)),
            Expanded(
              child:  FutureBuilder(future: _recvlist, builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Text(
                        "No pending requests.");
                  }
                  else {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Column(children: <Widget>[
                            snapshot.data![index]
                          ]);
                        });
                  }
                }
                else {
                  return const CircularProgressIndicator();
                }
              }),
            ),
            const Text("Outgoing Requests", style: TextStyle(
                fontSize: 40)),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.25,
              child: FutureBuilder(future: _sentlist, builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Text(
                        "No outgoing requests.");
                  }
                  else {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Column(children: <Widget>[
                            snapshot.data![index]
                          ]);
                        });
                  }
                }
                else {
                  return const CircularProgressIndicator();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
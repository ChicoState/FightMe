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
  late Future<List<Widget>> _list;
  late User curUser;

  Future<List<Widget>> _buildList() async {
    HttpService http = HttpService();
    List<Widget> list = List.empty(growable: true);
    List<FriendRequest> myRequests = await http.getAllFriendRequests(globals.uid);
    myRequests.removeWhere((element) => element.status == Status.rejected);
    for (var request in myRequests) {
      User user = await http.getUserByID(request.fromUserID);
      list.add(
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<ProfilePage>(
                        builder: (context) => ProfilePage(
                            curUser: curUser,
                            userViewed: user)));
              },
              child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: Image.asset(profilePictures[user.pfp], fit: BoxFit.cover, width: 60, height: 60),
                  ),
                title: user.id != 0 ? Text(user.name) : const Text("Group"),
                trailing: request.status == Status.pending ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FilledButton.tonal(
                        onPressed: () {
                          http.acceptFriendRequest(request.id).then((result){
                            return;
                          });
                          List<int> userIDs = [curUser.id, user.id];
                          http.postChatroom(userIDs).then((result){
                            return;
                          });
                          setState(() {
                            _list = _buildList();
                          });
                        },
                        child: const Text("accept"),
                      ),
                      FilledButton.tonal(
                        onPressed: () {
                          http.rejectFriendRequest(request.id).then((result){
                            return;
                          });
                          setState(() {
                            _list = _buildList();
                          });
                        },
                        child: const Text("reject"),
                      )
                    ]
                ) : ElevatedButton(
                    onPressed: () =>
                        buildFightButton(context, FightGameSession(curUser, user)),
                    child: const Text('Fight!')
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
    HttpService().getUserByID(globals.uid).then((result) {
      curUser =  result;
    });
    _list = _buildList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Requests"),
      ),
      body: Center(
        child: Column(
          children: [
            FutureBuilder(future: _list, builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
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
          ],
        ),
      ),
    );
  }
}
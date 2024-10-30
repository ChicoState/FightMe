import 'package:flutter/material.dart';
import 'package:fightme_webapp/Models/httpservice.dart';
import 'profile_page.dart';
import 'package:fightme_webapp/Models/user.dart';
import 'package:fightme_webapp/Models/friend_request.dart';
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
    myRequests.removeWhere((element) => element.status != Status.pending);
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
                leading: const Icon(Icons.account_circle_sharp),
                title: user.id != 0 ? Text(user.name) : const Text("Group"),
                trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FilledButton.tonal(
                        onPressed: () {
                          http.acceptFriendRequest(request.id).then((result){
                            return;
                          });
                          setState(() {
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
                          });
                        },
                        child: const Text("reject"),
                      )
                    ]
                )
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
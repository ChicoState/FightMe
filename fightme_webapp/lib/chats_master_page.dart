import 'package:fightme_webapp/searchbar.dart';
import 'package:flutter/material.dart';
import 'Models/chatroom.dart';
import 'chat_page.dart';
import 'Models/user.dart';
import 'package:fightme_webapp/Models/httpservice.dart';
import 'pending_requests.dart';
import 'globals.dart' as globals;

class ChatsMasterPage extends StatefulWidget {
  final User curUser;

  const ChatsMasterPage({super.key, required this.curUser});

  @override
  State<ChatsMasterPage> createState() => ChatsMasterPageState();
}


class ChatsMasterPageState extends State<ChatsMasterPage> {
  late Future<List<Widget>> _list = Future.value([]);
  late User curUser;
  late List<User> suggestedFriends = [];


  Future<List<Widget>> _buildList() async {
    List<Widget> list = List.empty(growable: true);
    List<Chatroom> chats = await HttpService().getChatroomsByUserId(curUser.id);
    for (var chat in chats) {
      // Best to set this up now so that it can handle group chat functionality instead of rewriting later.
      if (chat.users.length == 2) {
        if (chat.users.first.id != curUser.id) {
          list.add(_buildItem(chat.users.first, chat));
        }
        else {
          list.add(_buildItem(chat.users.last, chat));
        }
      }
      else {
        list.add(_buildItem(User("placeholder"), chat));
      }
    }
    return list;
  }

  Widget _buildItem(User user, Chatroom room) {
    return TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute<ChatPage>(
                  builder: (context) => ChatPage(
                    chatroomID: room.id,
                    currentUser: curUser,
                    currentUID: curUser.id,
                    otherUser: user,
                    otherUID: user.id,
                  )));
        },
        child: ListTile(
          leading: const Icon(Icons.account_circle_sharp),
          title: user.id != 0 ? Text(user.name) : const Text("Group"),
          subtitle: room.messages.isEmpty ? const Text("") : Text(room.messages.last.content),
        )
    );
  }

  @override
  void initState() {
    super.initState();
    curUser = widget.curUser;
    _list = _buildList();
    HttpService().getSuggestedFriends(globals.uid).then((value) {
      setState(() {
        suggestedFriends = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats", style: TextStyle(fontSize: 30)),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate(suggestedFriends, curUser));
            },
            icon: const Icon(Icons.search, size: 40),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<PendingRequestsPage>(
                          builder: (context) => const PendingRequestsPage()));
                },
                child: const Text("Pending Requests"),
            ),
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
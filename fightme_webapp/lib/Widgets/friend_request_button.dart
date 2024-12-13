import 'package:flutter/material.dart';
import 'package:fightme_webapp/Models/httpservice.dart';
import 'package:fightme_webapp/chat_page.dart';
import 'package:fightme_webapp/Models/friend_request.dart';
import 'package:fightme_webapp/Models/fight_game_session.dart';
import 'package:fightme_webapp/Models/user.dart';
import 'package:fightme_webapp/Models/chatroom.dart';
import 'fightButton.dart';


class FriendButton extends StatefulWidget {
  final User curUser;
  final User otherUser;
  const FriendButton({super.key, required this.curUser, required this.otherUser});

  @override
  State<FriendButton> createState() => _FriendButtonState();
}

class _FriendButtonState extends State<FriendButton> {
  HttpService http = HttpService();
  late Future<List<FriendRequest>> _friendPair = Future.value([]);

  Future<List<FriendRequest>> getFriendPair() async {
    List<FriendRequest> friendPair = List<FriendRequest>.empty(growable: true);
    friendPair.add(await http.getFriendRequest(
        widget.otherUser.id, widget.curUser.id));
    friendPair.add(await http.getFriendRequest(
        widget.curUser.id, widget.otherUser.id));
    return friendPair;
  }

  @override
  void initState() {
    super.initState();
    _friendPair = getFriendPair();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _friendPair,
        builder: (BuildContext context, AsyncSnapshot<List<FriendRequest>> wid) {
          if (wid.hasData) {
            FriendRequest incoming = wid.data![0];
            FriendRequest outgoing = wid.data![1];
            // TODO: Figure out how to get this value initialized only when accepted conditions are met.
            late Chatroom chat;
            http.getChatroomsByUserId(widget.curUser.id).then((result) {
              chat = result.firstWhere((element) =>
              element.users
                  .firstWhere((user) => user.id == widget.otherUser.id,
                  orElse: () => User("Gibby"))
                  .id != 0, orElse: () => Chatroom("Freddy"));
            });
            Widget friends = FilledButton.tonal(
              onPressed: () {
                if (chat.id != 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute<ChatPage>(
                          builder: (context) =>
                              ChatPage(
                                chatroomID: chat.id,
                                currentUser: widget.curUser,
                                currentUID: widget.curUser.id,
                                otherUser: widget.otherUser,
                                otherUID: widget.otherUser.id,
                              )));
                }
                else {
                  // TODO: Figure out what kind of error handling to do here.
                }
              },
              child: const Text("chat"),
            );
            Widget waitingResponse = Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.tonal(
                    onPressed: () {
                      http.acceptFriendRequest(incoming.id).then((result) {
                        http.postFightGame(widget.curUser, widget.otherUser,
                            widget.otherUser.id).then((result) {
                          return;
                        });
                        return;
                      });
                      setState(() {

                      });
                    },
                    child: const Text("accept"),
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      http.rejectFriendRequest(incoming.id).then((result) {
                        // final FriendsProvider friendsProvider = Provider.of<FriendsProvider>(context, listen: false);
                        // friendsProvider.removeFriend(otherUser);
                        return;
                      });
                      setState(() {

                      });
                    },
                    child: const Text("reject"),
                  )
                ]
            );
            Widget pending = Container(
              margin: const EdgeInsets.all(8.0),
              child: const Text('pending'),
            );
            Widget rejected = Container(
              margin: const EdgeInsets.all(8.0),
              child: const Text('rejected'),
            );

            FightGameSession fightGame = FightGameSession(widget.curUser, widget.otherUser);
            http.getFightGame(widget.curUser.id, widget.otherUser.id).then((result) {
              fightGame = result;
            });
            Widget fight = FilledButton.tonal(
                onPressed: () {
                  if (fightGame.id != 0) {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => FightButton(game: fightGame)
                    );
                  }
                },
                child: const Text('Fight!')
            );

            // isEmpty is the closest I can get to is null.
            // The bulk of the case section is based not on accessing when there isn't a friend request.
            if (!incoming.isEmpty() && !outgoing.isEmpty()) {
              if (incoming.status == Status.accepted &&
                  outgoing.status == Status.accepted) {
                return friends;
              }
              else if (incoming.status == Status.accepted &&
                  outgoing.status == Status.pending) {
                return fight;
              }
              else if (incoming.status == Status.pending &&
                  outgoing.status == Status.accepted) {
                return fight;
              }
              else if (incoming.status == Status.rejected &&
                  outgoing.status == Status.pending) {
                return pending;
              }
              else if (incoming.status == Status.pending &&
                  outgoing.status == Status.rejected) {
                return waitingResponse;
              }
              else if (incoming.status == Status.rejected &&
                  outgoing.status == Status.rejected) {
                return rejected;
              }
            }
            else if (!outgoing.isEmpty() && incoming.isEmpty()) {
              switch (outgoing.status) {
                case Status.accepted:
                  http.sendFriendRequest(widget.otherUser.id, widget.curUser.id).then((
                      result) {
                    if (fightGame.id == 0) {
                      http.postFightGame(widget.curUser, widget.otherUser, widget.curUser.id).then((
                          result) {
                        return;
                      });
                    }
                    return;
                  });
                  setState(() {

                  });
                  return fight;
                case Status.pending:
                  return pending;
                default:
                  return rejected;
              }
            }
            else if (outgoing.isEmpty() && !incoming.isEmpty()) {
              switch (incoming.status) {
                case Status.accepted:
                  http.sendFriendRequest(widget.curUser.id, widget.otherUser.id).then((
                      result) {
                    if (fightGame.id == 0) {
                      http.postFightGame(widget.curUser, widget.otherUser, widget.otherUser.id)
                          .then((result) {
                        return;
                      });
                    }
                    return;
                  });
                  return fight;
                case Status.pending:
                  return waitingResponse;
                default:
              }
            }


            return FilledButton.tonal(
              onPressed: () {
                http.sendFriendRequest(widget.curUser.id, widget.otherUser.id).then((result) {
                  return;
                });
                setState(() {

                });
              },
              child: const Text("add Friend"),
            );
          }
          return const CircularProgressIndicator();
        });
  }
}
import 'package:flutter/material.dart';
import 'package:fightme_webapp/Models/httpservice.dart';
import 'package:fightme_webapp/chat_page.dart';
import 'package:fightme_webapp/Models/friend_request.dart';
import 'package:fightme_webapp/Models/user.dart';
import 'package:fightme_webapp/Models/chatroom.dart';


Future<Widget> buildFriendButton(BuildContext context, VoidCallback update, User otherUser, User curUser) async {
  HttpService http = HttpService();
  List<FriendRequest> myRequests = await http.getAllFriendRequests(curUser.id);
  List<FriendRequest> otherRequests = await http.getAllFriendRequests(otherUser.id);
  FriendRequest? outgoing = otherRequests.firstWhere((element) => element.fromUserID == curUser.id, orElse: () => FriendRequest.empty());
  FriendRequest? incoming = myRequests.firstWhere((element) => element.fromUserID == otherUser.id, orElse: () => FriendRequest.empty());
  // TODO: Figure out how to get this value initialized only when accepted conditions are met.
  late Chatroom chat;
  http.getChatroomsByUserId(curUser.id).then((result) {
    chat = result.firstWhere((element) => element.users.firstWhere((user) => user.id == otherUser.id, orElse: () => User("Gibby")).id != 0, orElse: () => Chatroom("Freddy"));
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
                      currentUser: curUser,
                      currentUID: curUser.id,
                      otherUser: otherUser,
                      otherUID: otherUser.id,
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
          http.acceptFriendRequest(incoming.id).then((result){
            return;
          });
          List<int> userIDs = [curUser.id, otherUser.id];
          http.postChatroom(userIDs).then((result){
            return;
          });
          update();
        },
        child: const Text("accept"),
      ),
      FilledButton.tonal(
        onPressed: () {
          http.rejectFriendRequest(incoming.id).then((result){
            return;
          });
          update();
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

  // isEmpty is the closest I can get to is null.
  // The bulk of the case section is based not on accessing when there isn't a friend request.
  if (!incoming.isEmpty() && !outgoing.isEmpty()) {
    if (incoming.status == Status.accepted && outgoing.status == Status.accepted) {
      return friends;
    }
    else if (incoming.status == Status.rejected && outgoing.status == Status.pending) {
      return pending;
    }
    else if (incoming.status == Status.pending && outgoing.status == Status.rejected) {
      return waitingResponse;
    }
    else if (incoming.status == Status.rejected && outgoing.status == Status.rejected) {
      return rejected;
    }
  }
  else if (!outgoing.isEmpty() && incoming.isEmpty()) {
    switch(outgoing.status) {
      case Status.accepted:
        return friends;
      case Status.pending:
        return pending;
      default:
        return rejected;
    }
  }
  else if (outgoing.isEmpty() && !incoming.isEmpty()) {
    switch(incoming.status) {
      case Status.accepted:
        return friends;
      case Status.pending:
        return waitingResponse;
      default:
    }
  }


  return FilledButton.tonal(
    onPressed: () {
      http.sendFriendRequest(curUser.id, otherUser.id).then((result){
        return;
      });
      update();
    },
    child: const Text("add Friend"),
  );
}
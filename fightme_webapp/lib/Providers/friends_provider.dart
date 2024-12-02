import 'package:fightme_webapp/Models/httpservice.dart';
import 'package:fightme_webapp/Models/user.dart';
import 'package:flutter/material.dart';

class FriendsProvider extends ChangeNotifier {
  List<User> _friends = [];

  get friends => _friends;

  void initializeFriends(List<User> friends) {
    _friends = friends;
    notifyListeners();
  }

    Future<void> fetchFriends(int userId) async {
    try {
      _friends = await HttpService().getFriends(userId);
      notifyListeners();
    } catch (e) {
      print('Error fetching friends: $e');
      _friends = [];
    }
  }

  void addFriend(User friend) {
    if (!_friends.any((f) => f.id == friend.id)) {
      _friends.add(friend);
      notifyListeners();
    }
  }

  // Remove a friend
  void removeFriend(User friend) {
    _friends.removeWhere((f) => f.id == friend.id);
    notifyListeners();
  }
}
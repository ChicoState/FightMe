import 'package:fightme_webapp/Models/user.dart';
import 'package:fightme_webapp/profile_page.dart';
import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<User> suggestedFriends;
  final User curUser;

  CustomSearchDelegate(this.suggestedFriends, this.curUser);

  @override
  List<Widget> buildActions(BuildContext context) {
    return[
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<User> users = [];
    for (User user in suggestedFriends) {
      if (user.name.toLowerCase().contains(query.toLowerCase())) {
        users.add(user);
      }
    }
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(users[index].name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<ProfilePage>(builder: (BuildContext context) { 
                return ProfilePage(curUser: curUser, userViewed: users[index]);
               }
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<User> users = [];
    for (User user in suggestedFriends) {
      if (user.name.toLowerCase().contains(query.toLowerCase())) {
        users.add(user);
      }
    }
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(users[index].name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<ProfilePage>(builder: (BuildContext context) { 
                return ProfilePage(curUser: curUser, userViewed: users[index]);
               }
              ),
            );
          },
        );
      },
    );
  }
}
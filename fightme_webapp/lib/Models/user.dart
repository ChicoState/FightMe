import 'dart:convert';
import 'package:fightme_webapp/Cosmetics/profile_pictures.dart';
import 'package:http/http.dart';

import 'package:flutter/material.dart';

class User {
  int id = 0;
  String name = "";
  String email = "";
  String password = "";
  int dateCreated = 0;
  int gamerScore = 0;
  int attackScore = 0;
  int defenseScore = 0;
  int magicScore = 0;
  int pfp = 0;
  List<int> unlockedpfps = [0];
  int theme = 0;
  List<int> unlockedThemes = [0];

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    dateCreated = json['dateCreated'];
    gamerScore = json['gamerScore'];
    attackScore = json['attackScore'];
    defenseScore = json['defenseScore'];
    magicScore = json['magicScore'];
    pfp = json['profilePicture'];
    unlockedpfps = List.from(json['unlockedProfilePictures']);
    theme = json['theme'];
    unlockedThemes = List.from(json['unlockedThemes']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'dateCreated': dateCreated,
        'gamerScore': gamerScore,
        'attackScore': attackScore,
        'defenseScore': defenseScore,
        'magicScore': magicScore,
        'profilePicture': pfp,
        'unlockedProfilePictures': unlockedpfps,
        'theme': theme,
        'unlockedThemes': unlockedThemes,
      };

  User(String n) {
    id = 0;
    name = n;
    email = n;
    password = n;
    dateCreated = 0;
    gamerScore = 0;
    attackScore = 0;
    defenseScore = 0;
    magicScore = 0;
    pfp = 0;
    unlockedpfps = [0];
    theme = 0;
    unlockedThemes = [0];
  }
}

import 'dart:convert';
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

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    dateCreated = json['dateCreated'];
    gamerScore = json['gamerScore'];
    attackScore = json['attackScore'];
    defenseScore = json['defenseScore'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'dateCreated': dateCreated,
        'gamerScore': gamerScore,
        'attackScore' : attackScore,
        'defenseScore' : defenseScore,
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
  }
}

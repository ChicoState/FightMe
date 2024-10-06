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

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    dateCreated = json['dateCreated'];
    gamerScore = json['gamerScore'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'dateCreated': dateCreated,
        'gamerScore': gamerScore
      };

  User(String n) {
    id = 0;
    name = n;
    email = n;
    password = n;
    dateCreated = 0;
    gamerScore = 0;
  }
}

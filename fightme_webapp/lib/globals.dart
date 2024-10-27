import 'dart:convert';
import 'package:http/http.dart';
import 'chat_page.dart';
import 'navbar.dart';
import 'Models/chatroom.dart';
import 'Models/message.dart';
import 'Models/user.dart';
import 'Models/httpservice.dart';
import 'package:flutter/material.dart';

bool loggedIn = false;
int uid = 0;

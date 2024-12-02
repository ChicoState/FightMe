import 'package:fightme_webapp/Models/user.dart';
import 'package:flutter/material.dart';

class StatsProvider extends ChangeNotifier {

  int _attack = 0;
  int _magic = 0;
  int _defense = 0;
  int _gamerscore = 0;

  // Getters for the stats
  int get attack => _attack;
  int get magic => _magic;
  int get defense => _defense;
  int get gamerscore => _gamerscore;

  // Initialize stats from global user
  Future<void> initializeStats(User user) async {
    _attack = user.attackScore;
    _magic = user.magicScore;
    _defense = user.defenseScore;
    _gamerscore = user.gamerScore;
    notifyListeners();
  }

  // Update stats
  void updateStats(int attack, int magic, int defense) {
    _attack = attack;
    _magic = magic;
    _defense = defense;
    notifyListeners();
  }

  //Update gamerscore
  void updateGamerscore(int gamerscore) {
    _gamerscore = gamerscore;
    notifyListeners();
  }
}
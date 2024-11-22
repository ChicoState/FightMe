import 'user.dart';

// Action is already named in library.
enum Move {attack, defense, magic, none}

class FightGameSession {
  int id = 0;
  User user1 = User("");
  int user1hp = 5;
  Move user1move = Move.none;
  User user2 = User("");
  int user2hp = 5;
  Move user2move = Move.none;
  int turn = 1;

  FightGameSession(User curUser, otherUser) {
    id = 0;
    user1 = curUser;
    user1hp = 5;
    user1move = Move.none;
    user2 = otherUser;
    user2hp = 5;
    user2move = Move.none;
    turn = 1;
  }

  FightGameSession.practice(User curUser) {
    id = 0;
    user1 = curUser;
    user1hp = 5;
    user1move = Move.none;
    user2 = User("Dummy");
    // TODO: Set Dummy's profile picture to a picture of something like a straw man.
    user2.attackScore = curUser.attackScore;
    user2.defenseScore = curUser.defenseScore;
    user2.magicScore = curUser.magicScore;
    user2hp = 5;
    user2move = Move.none;
    turn = 1;
  }
}
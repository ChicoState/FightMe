import 'user.dart';

// Action is already named in library.
enum Move {attack, defense, magic, none}

class FightGameSession {
  int id = 0;
  int winnerID = 0;
  User user1 = User("");
  bool forRequest = false;
  int user1hp = 5;
  List<Move> user1moves = [Move.none];
  User user2 = User("");
  int user2hp = 5;
  List<Move> user2moves = [Move.none];

  FightGameSession.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    winnerID = json['winnerID'];
    user1 = json['user1'];
    user2 = json['user2'];
    user1hp = json['user1HP'];
    Map<int, List<String>> moves = json['moves'];
    for (var move in moves[user1.id]!) {
      user1moves.add((move == 'ATTACK') ? Move.attack : (move == 'DEFENSE')
          ? Move.defense : (move == 'MAGIC') ? Move.magic : Move.none);
    }
    user2hp = json['user2HP'];
    for (var move in moves[user2.id]!) {
      user2moves.add((move == 'ATTACK') ? Move.attack : (move == 'DEFENSE')
          ? Move.defense : (move == 'MAGIC') ? Move.magic : Move.none);
    }
  }

  FightGameSession(User curUser, otherUser) {
    id = 0;
    winnerID = 0;
    user1 = curUser;
    forRequest = false;
    user1hp = 5;
    user1moves = [Move.none];
    user2 = otherUser;
    user2hp = 5;
    user2moves = [Move.none];
  }

  FightGameSession.practice(User curUser) {
    id = 0;
    winnerID = 0;
    user1 = curUser;
    user1hp = 5;
    user1moves = [Move.none];
    forRequest = false;
    user2 = User("Dummy");
    user2.pfp = 1;
    user2.attackScore = curUser.attackScore;
    user2.defenseScore = curUser.defenseScore;
    user2.magicScore = curUser.magicScore;
    user2hp = 5;
    user2moves = [Move.none];
  }
}
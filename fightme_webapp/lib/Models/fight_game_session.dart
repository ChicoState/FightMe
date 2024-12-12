import 'user.dart';

// Action is already named in library.
enum Move {attack, defense, magic, none}

class FightGameSession {
  int id = 0;
  int winnerID = 0;
  int requesterID = 0;
  User user1 = User("");
  int user1hp = 5;
  List<Move> user1moves = [Move.none];
  User user2 = User("");
  int user2hp = 5;
  List<Move> user2moves = [Move.none];

  FightGameSession.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    winnerID = json['winnerID'];
    requesterID = json['requesterID'];
    user1 = User.fromJson(json['user1']);
    user2 = User.fromJson(json['user2']);
    user1hp = json['user1HP'];
    user1moves = [];
    for (var move in json['user1Moves']) {
      user1moves.add((move == 'ATTACK') ? Move.attack : (move == 'DEFENSE')
          ? Move.defense : (move == 'MAGIC') ? Move.magic : Move.none);
    }
    user2hp = json['user2HP'];
    user2moves = [];
    for (var move in json['user2Moves']) {
      user2moves.add((move == 'ATTACK') ? Move.attack : (move == 'DEFENSE')
          ? Move.defense : (move == 'MAGIC') ? Move.magic : Move.none);
    }
  }

  Map<String, dynamic> toJson(){
    List<String> user1MovesToJson= [];
    List<String> user2MovesToJson= [];
    for(var move in user1moves){
      user1MovesToJson.add(move.name.toString().toUpperCase());
    }
    for(var move in user2moves){
      user2MovesToJson.add(move.name.toString().toUpperCase());
    }
    return{
      'id': id,
      'winnerID': winnerID,
      'requesterID': requesterID,
      'user1': user1.toJson(),
      'user2': user2.toJson(),
      'user1HP': user1hp,
      'user2HP': user2hp,
      'user1Moves': user1MovesToJson,
      'user2Moves': user2MovesToJson
    };
  }

  FightGameSession(User curUser, otherUser) {
    id = 0;
    winnerID = 0;
    requesterID = 0;
    user1 = curUser;
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
    requesterID = 0;
    user2 = User("Dummy");
    user2.pfp = 1;
    user2.attackScore = curUser.attackScore;
    user2.defenseScore = curUser.defenseScore;
    user2.magicScore = curUser.magicScore;
    user2hp = 5;
    user2moves = [Move.none];
  }

  int getUserHp(int userID) {
    if (userID == user1.id) {
      return user1hp;
    }
    else if (userID == user2.id){
      return user2hp;
    }
    else {
      return -1;
    }
  }

  int getOtherUserHp(int userID) {
    if (userID != user1.id && userID != user2.id) {
      return -1;
    }
    else if (userID != user1.id) {
      return user1hp;
    }
    else {
      return user2hp;
    }
  }

  List<Move> getUserMoves(int userID) {
    if (userID == user1.id) {
      return user1moves;
    }
    else if (userID == user2.id){
      return user2moves;
    }
    else {
      return List.empty();
    }
  }

  List<Move> getOtherUserMoves(int userID) {
    if (userID != user1.id && userID != user2.id) {
      return List.empty();
    }
    else if (userID != user1.id) {
      return user1moves;
    }
    else {
      return user2moves;
    }
  }

  User getOtherUser(int userID) {
    if (userID != user1.id && userID != user2.id) {
      return User("All work");
    }
    else if (userID != user1.id) {
      return user1;
    }
    else {
      return user2;
    }
  }
}
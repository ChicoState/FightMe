class Conversation {
  Conversation(
      {required this.recipientUID,
      required this.recipientUsername,
      required this.recipientScore,
      required this.lastMessage});
  int recipientUID;
  int recipientScore;
  String lastMessage;
  String recipientUsername;
}

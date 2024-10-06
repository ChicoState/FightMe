class Message {
  int fromId = 0;
  int toId = 0;
  String content = "";
  bool isRead = false;
  DateTime timeStamp = DateTime(0);

  Message.fromJson(Map<String, dynamic> json) {
    fromId = json['fromId'];
    toId = json['toId'];
    content = json['content'];
    isRead = json['isRead'];
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() => {
        'fromId': fromId,
        'toId': toId,
        'content': content,
        'isRead': isRead,
        'timeStamp': timeStamp
      };

  Message(int to, int from, String text) {
    toId = to;
    fromId = from;
    content = text;
    isRead = false;
    timeStamp = DateTime.now();
  }
}

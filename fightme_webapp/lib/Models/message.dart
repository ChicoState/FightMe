class Message {
  int fromId = 0;
  int toId = 0;
  int chatroomId = 0;
  String content = "";
  bool isRead = false;
  int timeStamp = 0;

  Message.fromJson(Map<String, dynamic> json) {
    fromId = json['fromId'];
    toId = json['toId'];
    content = json['content'];
    isRead = json['isRead'];
    timeStamp = json['timeStamp'];
    chatroomId = json['chatroomId'];
  }

  Map<String, dynamic> toJson() => {
        'fromId': fromId,
        'toId': toId,
        'content': content,
        'isRead': isRead,
        'timeStamp': timeStamp,
        'chatroomId': chatroomId
      };

  Message(int to, int from, String text, int chatId) {
    toId = to;
    fromId = from;
    content = text;
    isRead = false;
    timeStamp = 0;
    chatroomId = chatId;
  }
}

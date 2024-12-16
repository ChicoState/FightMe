enum Status { pending, accepted, rejected }

class FriendRequest {
  int id = 0;
  int fromUserID = 0;
  int toUserID = 0;
  Status status = Status.pending;

  FriendRequest.empty() {
    id = 0;
    fromUserID = 0;
    toUserID = 0;
    status = Status.pending;
  }

  bool isEmpty() {
    return id == 0 &&
        fromUserID == 0 &&
        toUserID == 0 &&
        status == Status.pending;
  }

  FriendRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromUserID = json['fromUserID'];
    toUserID = json['toUserID'];
    status = (json['status'] == 'STATUS.PENDING')
        ? Status.pending
        : (json['status'] == 'STATUS.ACCEPTED')
            ? Status.accepted
            : Status.rejected;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fromUserID': fromUserID,
        'toUserID': toUserID,
        'status': status.toString().toUpperCase()
      };
}

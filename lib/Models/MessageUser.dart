class MessageUser {
  String? id;
  String? photoUrl;
  String? nickname;
  String? message;
  int? time;
  String? type;
  String count = "";

  Duration? nudgeReceiver;
  Duration? nudgeSender;
  bool isNudgeSent = false;

  MessageUser(this.id, this.photoUrl, this.nickname);

  Map<String, dynamic> ToJson() => <String, dynamic>{
    'id': id,
    'nickname': nickname,
    'photoUrl': photoUrl,
  };
}

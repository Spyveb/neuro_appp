class NotificationL {
  String notification = "";

  NotificationL();

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['notification'] = notification;
    return map;
  }
}

class Report {
  String user_id = "";
  String description = "";

  Report();

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['user_id'] = user_id;
    map['description'] = description;
    return map;
  }
}

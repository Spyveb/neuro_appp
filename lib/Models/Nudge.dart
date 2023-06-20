class Nudge {
  String budge_no = "";

  String message = "";
  bool isDone = false;

  Nudge();

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['budge_no'] = "5";
    return map;
  }
}

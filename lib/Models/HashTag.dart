class HashTag {
  String id = "";
  String name = "";
  bool isSelected = false;

  String message = "";

  HashTag();

  HashTag.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
    } catch (e) {
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['name'] = name;
    return map;
  }

  @override
  String toString() {
    return 'HashTag{id: $id, name: $name, isSelected: $isSelected, message: $message}';
  }
}

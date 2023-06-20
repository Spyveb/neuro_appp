class FirebaseUser {
  String id = "";
  String name = "";
  String image = "";
  bool isAdmin = false;

  FirebaseUser();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['isAdmin'] = this.isAdmin;
    return data;
  }

  FirebaseUser.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'].toString();
      image = jsonMap['image'].toString();
      isAdmin = jsonMap['isAdmin'];
    } catch (e) {
      print(e);
    }
  }
}

class Matches {
  String FromImage = "";
  String ToImage = "";

  String id = "";
  String name = "";
  String birthdate = "";
  String profile_img = "";
  String address = "";

  Matches();

  Matches.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'].toString();
      birthdate = jsonMap['birthdate'].toString();
      profile_img = jsonMap['profile_img'].toString();
      address = jsonMap['address'].toString();
    } catch (e) {
      print(e);
    }
  }
}

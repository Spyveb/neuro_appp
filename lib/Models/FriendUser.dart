class FriendUser {
  String id = "";
  String name = "";
  String birthdate = "";
  String profile_img = "";
  String address = "";
  bool isSelected = false;
  bool admin = false;

  String groupID ="";

  FriendUser();

  FriendUser.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'].toString();
      birthdate = jsonMap['birthdate'].toString();
      profile_img = jsonMap['profile_img'].toString();
      address = jsonMap['address'].toString();
      isSelected = jsonMap['check_group'];
    } catch (e) {
      print(e);
    }
  }

  Map toMap(){
    var map = new Map<String,dynamic>();
    map['group_id'] = groupID;
    return map;
  }
}

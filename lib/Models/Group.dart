class Group {
  String id = "";
  String admin_id = "";
  String group_name = "";
  String about = "";
  String group_img = "";
  bool admin = false;
  List<dynamic> image = <dynamic>[];

  String name = "";
  String age = "";
  String profile_img = "";
  String address = "";

  List<Group> group_members = <Group>[];

  String group_id = "";
  String member_id = "";
  String isAdd = "";

  Group();

  Group.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      admin_id = jsonMap['admin_id'].toString();
      group_name = jsonMap['group_name'].toString();
      about = jsonMap['about'].toString();
      group_img = jsonMap['group_img'].toString();
      admin = jsonMap['admin'];
      image = jsonMap['image'] as List<dynamic>;
    } catch (e) {
      print(e);
    }
  }

  Group.fromJSONDETAILS(Map<String, dynamic> jsonMap) {
    try {
      var group_data = jsonMap['group_data'];
      id = group_data['id'].toString();
      admin_id = group_data['admin_id'].toString();
      group_name = group_data['group_name'].toString();
      about = group_data['about'].toString();
      group_img = group_data['group_img'].toString();
      admin = group_data['admin'];
      group_members = (jsonMap['group_members'] as List)
          .map((e) => Group.fromJSONDETAILSMEMEBR(e))
          .toList();
    } catch (e) {
      print(e);
    }
  }

  Group.fromJSONDETAILSMEMEBR(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'].toString();
      age = jsonMap['age'].toString();
      profile_img = jsonMap['profile_img'].toString();
      address = jsonMap['address'].toString();
      admin = jsonMap['admin'];
    } catch (e) {
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['group_id'] = id;
    return map;
  }

  Map toMapAddRemove() {
    var map = new Map<String, dynamic>();
    map['group_id'] = group_id;
    map['member_id'] = member_id;
    map['isAdd'] = isAdd;
    return map;
  }
}

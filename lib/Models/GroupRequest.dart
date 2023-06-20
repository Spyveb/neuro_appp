class GroupRequest {
  String id = "";
  String admin_id = "";
  String group_name = "";
  String about = "";
  String group_img = "";
  List<dynamic> image = <dynamic>[];

  GroupRequest();

  GroupRequest.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      admin_id = jsonMap['admin_id'].toString();
      group_name = jsonMap['group_name'].toString();
      about = jsonMap['about'].toString();
      group_img = jsonMap['group_img'].toString();
      image = jsonMap['image'] as List<dynamic>;
    } catch (e) {
      print(e);
    }
  }
}

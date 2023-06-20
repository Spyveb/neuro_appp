import 'package:neuro/Models/FirebaseUser.dart';

class GroupUser {
  String id = "";
  String group_name = "";
  String group_img = "";
  String group_topic = "";
  String content = "";
  String type = "";
  String count = "";
  int time = 0;
  List<FirebaseUser> list_member = <FirebaseUser>[];

  GroupUser();

  Map<String, dynamic> ToJson() => <String, dynamic>{
    'id': id,
    'group_name': group_name,
    'group_img': group_img,
    'group_topic': group_topic,
    'content': content,
    'type': type,
    'count': count,
    'time': time,
    'list_member' : list_member.map((e) => e.toJson()).toList(),
  };
}

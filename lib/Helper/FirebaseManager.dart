import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Models/FirebaseUser.dart';
import 'package:neuro/Models/GroupUser.dart';
import 'package:neuro/Models/MessageUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PlayerWidget.dart';

class FirebaseManager extends Object {
  List<MessageUser>? list_user = <MessageUser>[];

  List<MessageUser>? get list_users => list_user;

  List<GroupUser>? list_group = <GroupUser>[];

  List<GroupUser>? get list_groups => list_group;

  PlayerWidgetStateLeft? playerWidgetLeft;
  PlayerWidgetState? playerWidgetRight;

  Function? callback;

  factory FirebaseManager() {
    return _singleton;
  }

  static final FirebaseManager _singleton = new FirebaseManager._internal();

  FirebaseManager._internal() {
    print("======== Firebase Manager instance created ========");
  }

  _removeUser(String peerId, String userId) {
    FirebaseFirestore.instance
        .collection('recentusers')
        .doc(peerId)
        .collection(peerId)
        .doc(userId)
        .delete();
  }

  void setList(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) async {
    list_user = <MessageUser>[];
    docs.forEach((element) async {
      var prefs = await SharedPreferences.getInstance();
      String currentUserId = prefs.getString(Constant.USERID) ?? '';
      String peerId = "";
      String groupChatId = "";
      try {
        if (currentUserId == element.get("idFrom")) {
          peerId = element.get("idTo");
        } else {
          peerId = element.get("idFrom");
        }
      } catch (e) {}
      if (prefs.containsKey(peerId)) {
        int? peerIDTimeStamp = prefs.getInt(peerId);
        if (currentUserId.hashCode <= peerId.hashCode) {
          groupChatId = '$currentUserId-$peerId';
        } else {
          groupChatId = '$peerId-$currentUserId';
        }

        String count = "";
        MessageUser data = MessageUser("", "", "");
        int create_at;
        DateTime CreateAtDateTime;
        DateTime SeverDateTime;
        FirebaseFirestore.instance
            .collection('messages')
            .doc(groupChatId)
            .collection(groupChatId)
            .where("timestamp", isGreaterThan: peerIDTimeStamp)
            .get()
            .then((event) => {
                  print("message count " + event.docs.length.toString()),
                  if (event.docs.length > 0)
                    {
                      if (event.docs[0].get("idFrom") == currentUserId)
                        {
                          count = "",
                        }
                      else
                        {
                          count = event.docs.length.toString(),
                        },
                    }
                  else
                    {
                      count = "",
                    },
                  if (currentUserId == element.get("idFrom"))
                    {
                      data.id = element.get("idTo"),
                    }
                  else
                    {
                      data.id = element.get("idFrom"),
                    },
                  data.photoUrl = element.get('photoUrl'),
                  data.nickname = element.get('nickname'),
                  data.message = element.get('content'),
                  data.time = element.get("timestamp"),
                  data.type = element.get('type').toString(),
                  data.isNudgeSent = (element.data().containsKey("isNudgeSent")),
                  if (element.data().containsKey("nudgeReceiver"))
                    {
                      create_at = element.get("nudgeReceiver"),
                      CreateAtDateTime =
                          DateTime.fromMillisecondsSinceEpoch(create_at),
                      SeverDateTime = new DateFormat("yyyy-MM-dd hh:mm:ss")
                          .parse(DateTime.now().toString()),
                      data.nudgeReceiver = daysBetween(
                          CreateAtDateTime,
                          SeverDateTime,
                          element.data().containsKey("isNudgeSent")),
                      if (data.nudgeReceiver!.isNegative)
                        {
                          _removeUser(
                              element.get("idFrom"), element.get("idTo")),
                          _removeUser(
                              element.get("idTo"), element.get("idFrom"))
                        }
                    },
                  if (element.data().containsKey("nudgeSender"))
                    {
                      create_at = element.get("nudgeSender"),
                      CreateAtDateTime =
                          DateTime.fromMillisecondsSinceEpoch(create_at),
                      SeverDateTime = new DateFormat("yyyy-MM-dd hh:mm:ss")
                          .parse(DateTime.now().toString()),
                      data.nudgeSender = daysBetween(
                          CreateAtDateTime,
                          SeverDateTime,
                          element.data().containsKey("isNudgeSent")),
                      if (data.nudgeSender!.isNegative)
                        {
                          _removeUser(
                              element.get("idFrom"), element.get("idTo")),
                          _removeUser(
                              element.get("idTo"), element.get("idFrom"))
                        }
                    },
                  if (count != "")
                    {
                      data.count = count,
                    },
                  list_user!.add(data),
                  if (this.callback != null)
                    {
                      this.callback!(),
                    },
                });
      } else {
        DateTime CreateAtDateTime;
        MessageUser data = MessageUser("", "", "");
        if (currentUserId == element.get("idFrom")) {
          data.id = element.get("idTo");
        } else {
          data.id = element.get("idFrom");
        }
        data.isNudgeSent = (element.data().containsKey("isNudgeSent"));
        data.photoUrl = element.get('photoUrl');
        data.nickname = element.get('nickname');
        data.message = element.get('content');
        data.time = element.get("timestamp");
        if (element.data().containsKey("nudgeReceiver")) {
          int create_at = element.get("nudgeReceiver");
          CreateAtDateTime = new DateTime.fromMillisecondsSinceEpoch(create_at);
          DateTime SeverDateTime = new DateFormat("yyyy-MM-dd hh:mm:ss")
              .parse(DateTime.now().toString());
          data.nudgeReceiver = daysBetween(CreateAtDateTime, SeverDateTime,
              element.data().containsKey("isNudgeSent"));
          if (data.nudgeReceiver!.isNegative) {
            _removeUser(element.get("idFrom"), element.get("idTo"));
            _removeUser(element.get("idTo"), element.get("idFrom"));
          }
        }
        if (element.data().containsKey("nudgeSender")) {
          int create_at = element.get("nudgeSender");
          CreateAtDateTime = new DateTime.fromMillisecondsSinceEpoch(create_at);
          DateTime SeverDateTime = new DateFormat("yyyy-MM-dd hh:mm:ss")
              .parse(DateTime.now().toString());
          data.nudgeSender = daysBetween(CreateAtDateTime, SeverDateTime,
              element.data().containsKey("isNudgeSent"));
          if (data.nudgeSender!.isNegative) {
            _removeUser(element.get("idFrom"), element.get("idTo"));
            _removeUser(element.get("idTo"), element.get("idFrom"));
          }
        }
        data.type = element.get('type').toString();
        list_user!.add(data);
        if (this.callback != null) {
          this.callback!();
        }
      }
    });
  }

  Duration daysBetween(DateTime from, DateTime to, bool isNudge) {
    from = DateTime(
        from.year, from.month, from.day, from.hour, from.minute, from.second);
    to = DateTime(to.year, to.month, to.day, to.hour, to.minute, to.second);
    var seconds = to.difference(from).inSeconds;
    var houresecond = Duration(hours: isNudge ? 72 : 48).inSeconds;
    /**
     * need to minus 48 hours second
     */
    var finalSecond = (houresecond - seconds);

    var duration = new Duration(seconds: finalSecond);
    print(duration);
    return duration;
  }

  void getUserList() async {
    var prefs = await SharedPreferences.getInstance();
    String currentUserId = prefs.getString(Constant.USERID) ?? '';

    if (currentUserId != "" && currentUserId.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('recentusers')
          .doc(currentUserId)
          .collection(currentUserId)
          .snapshots()
          .listen((event) {
        setList(event.docs);
        print("list size :  ${event.docs.length}");
        if (this.callback != null) {
          this.callback!();
        }
      });
    }
    getGroupList();
  }

  void getGroupList() async {
    var prefs = await SharedPreferences.getInstance();
    String currentUserId = prefs.getString(Constant.USERID) ?? '';
    if (currentUserId != "" && currentUserId.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('recentgroups')
          .doc(currentUserId)
          .collection(currentUserId)
          .snapshots()
          .listen((event) {
        setListGroup(event.docs);
        print("list size group :  ${event.docs.length}");
        if (this.callback != null) {
          this.callback!();
        }
      });
    }
  }

  setListGroup(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) async {
    list_group = <GroupUser>[];
    var prefs = await SharedPreferences.getInstance();
    String currentUserId = prefs.getString(Constant.USERID) ?? '';
    docs.forEach((element) {
      String groupChatId = element.get('groupId');
      if (prefs.containsKey(groupChatId)) {
        int? peerIDTimeStamp = prefs.getInt(groupChatId);
        GroupUser dataAdd = new GroupUser();
        FirebaseFirestore.instance
            .collection('groupMessages')
            .doc(groupChatId)
            .collection(groupChatId)
            .where("timestamp", isGreaterThan: peerIDTimeStamp)
            .get()
            .then((value) => {
                  if (value.docs.length > 0)
                    {
                      /*if (value.docs[0].get("senderID") == currentUserId)
                        {
                          dataAdd.count = "",
                        }
                      else*/
                      //{
                      dataAdd.count = value.docs.length.toString(),
                      //},
                    }
                  else
                    {
                      dataAdd.count = "",
                    },
                  FirebaseFirestore.instance
                      .collection('groups')
                      .doc(groupChatId)
                      .get()
                      .then((value) => {
                            dataAdd.id = value.get("id"),
                            dataAdd.group_name = value.get("group_name"),
                            dataAdd.group_img = value.get("group_img"),
                            dataAdd.group_topic = value.get("group_topic"),
                            dataAdd.time = element.get("timestamp"),
                            dataAdd.content = element.get("content"),
                            dataAdd.type = element.get("type").toString(),
                            dataAdd.list_member =
                                (value.get('members') as List<dynamic>)
                                    .map((e) => FirebaseUser.fromJSON(e))
                                    .toList(),
                            list_group!.add(dataAdd),
                            if (this.callback != null)
                              {
                                this.callback!(),
                              }
                          }),
                });
      } else {
        GroupUser dataAdd = new GroupUser();
        FirebaseFirestore.instance
            .collection('groups')
            .doc(groupChatId)
            .get()
            .then((value) => {
                  dataAdd.id = value.get("id"),
                  dataAdd.group_name = value.get("group_name"),
                  dataAdd.group_img = value.get("group_img"),
                  dataAdd.group_topic = value.get("group_topic"),
                  dataAdd.count = "",
                  dataAdd.time = element.get("timestamp"),
                  dataAdd.content = element.get("content"),
                  dataAdd.type = element.get("type").toString(),
                  dataAdd.list_member = (value.get('members') as List<dynamic>)
                      .map((e) => FirebaseUser.fromJSON(e))
                      .toList(),
                  list_group!.add(dataAdd),
                  if (this.callback != null)
                    {
                      this.callback!(),
                    }
                });
      }
    });
  }
}

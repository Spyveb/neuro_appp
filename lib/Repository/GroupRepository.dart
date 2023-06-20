import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Models/CreateGroup.dart';
import 'package:neuro/Models/FirebaseUser.dart';
import 'package:neuro/Models/FriendUser.dart';
import 'package:neuro/Models/Group.dart';
import 'package:neuro/Models/GroupRequest.dart';
import 'package:neuro/Models/NeuroRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<CreateGroup> createGroup(
    CreateGroup data, List<FriendUser> list_data) async {
  final String url =
      "${GlobalConfiguration().getString("api_base_url")}add_group";
  print("$url");
  var token = "";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(Constant.TOKEN)) {
    token = prefs.getString(Constant.TOKEN)!;
  }
  String adminID = prefs.getString(Constant.USERID)!;
  String adminName = prefs.getString(Constant.NAME)!;
  String adminPhoto = prefs.getString(Constant.PROFILEIMAGE)!;

  List<FirebaseUser> list_member = <FirebaseUser>[];
  FirebaseUser dataAdmin = new FirebaseUser();
  dataAdmin.id = adminID;
  dataAdmin.name = adminName;
  dataAdmin.image = adminPhoto;
  dataAdmin.isAdmin = true;
  list_member.add(dataAdmin);

  Uri myUri = Uri.parse(url);
  var request = new http.MultipartRequest("POST", myUri);
  Map<String, String> headers = {
    HttpHeaders.authorizationHeader: 'Bearer $token'
  };
  request.headers.addAll(headers);
  request.fields['group_id'] = data.group_id;
  request.fields['group_name'] = data.group_name;
  request.fields['about'] = data.about;
  request.fields['members'] = data.members;

  if (data.group_img != null) {
    String fileName = data.group_img!.path.split("/").last;
    var stream =
        new http.ByteStream(DelegatingStream.typed(data.group_img!.openRead()));
    var length = await data.group_img!.length();
    var multipartFileSign =
        new http.MultipartFile('group_img', stream, length, filename: fileName);
    request.files.add(multipartFileSign);
  }
  CreateGroup returnData = new CreateGroup();
  http.Response response = await http.Response.fromStream(await request.send());
  print("Result: ${response.body}");
  var res = json.decode(response.body);
  if (res['success']) {
    var dataRes = res['data'];
    returnData.error = res['message'];
    returnData.isDone = true;
    FirebaseFirestore.instance
        .collection('groups')
        .doc(dataRes['group_id'].toString())
        .set({
      'id': dataRes['group_id'].toString(),
      'group_name': data.group_name,
      'group_topic': data.about,
      'group_img': dataRes['group_img'].toString(),
      'members': Helper.ConvertCustomStepsToMap(list_member),
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    var documentrecentReferencetoFrom = FirebaseFirestore.instance
        .collection('recentgroups')
        .doc(adminID)
        .collection(adminID)
        .doc(dataRes['group_id'].toString());
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentrecentReferencetoFrom, {
        'content': "",
        'type': 0,
        'groupId': dataRes['group_id'].toString(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    });
  } else {
    returnData.error = res['message'];
    returnData.isDone = false;
  }
  return returnData;
}

Future<List<GroupRequest>> getGroupListRequest() async {
  final String url =
      "${GlobalConfiguration().get("api_base_url")}group_request";
  print("$url");
  Uri myUri = Uri.parse(url);
  var token = "";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(Constant.TOKEN)) {
    token = prefs.getString(Constant.TOKEN)!;
  }

  final client = new http.Client();
  final response = await client.post(
    myUri,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    },
  );
  List<GroupRequest> returnData = <GroupRequest>[];
  if (response.statusCode == 200) {
    print(response.body.toString());
    var res = json.decode(response.body);
    if (res['success']) {
      returnData =
          (res['data'] as List).map((e) => GroupRequest.fromJSON(e)).toList();
    }
  } else {
    print(response.body.toString());
  }
  return returnData;
}

Future<bool> acceptrejectRequest(NeuroRequest data) async {
  final String url =
      "${GlobalConfiguration().get("api_base_url")}group_accept_request";
  print("$url");
  var token = "";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(Constant.TOKEN)) {
    token = prefs.getString(Constant.TOKEN)!;
  }
  Uri myUri = Uri.parse(url);
  final client = new http.Client();
  final response = await client.post(myUri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: json.encode(data.toMapGroup()));
  print(data.toMapGroup());
  if (response.statusCode == 200) {
    print(response.body.toString());
  } else {
    print(response.body.toString());
  }
  return true;
}

Future<List<Group>> getGroupList() async {
  final String url = "${GlobalConfiguration().get("api_base_url")}group_list";
  print("$url");
  Uri myUri = Uri.parse(url);
  var token = "";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(Constant.TOKEN)) {
    token = prefs.getString(Constant.TOKEN)!;
  }

  final client = new http.Client();
  final response = await client.post(
    myUri,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    },
  );
  List<Group> returnData = <Group>[];
  if (response.statusCode == 200) {
    print(response.body.toString());
    var res = json.decode(response.body);
    if (res['success']) {
      returnData = (res['data'] as List).map((e) => Group.fromJSON(e)).toList();
    }
  } else {
    print(response.body.toString());
  }
  return returnData;
}

Future<Group> getGroupInfo(Group sendDataGroupInfo) async {
  final String url = "${GlobalConfiguration().get("api_base_url")}group_info";
  print("$url");
  Uri myUri = Uri.parse(url);
  var token = "";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(Constant.TOKEN)) {
    token = prefs.getString(Constant.TOKEN)!;
  }

  final client = new http.Client();
  final response = await client.post(myUri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: json.encode(sendDataGroupInfo.toMap()));
  Group returnData = Group();
  if (response.statusCode == 200) {
    print(response.body.toString());
    var res = json.decode(response.body);
    if (res['success']) {
      returnData = Group.fromJSONDETAILS(res['data']);
    }
  } else {
    print(response.body.toString());
  }
  return returnData;
}

Future<CreateGroup> updateGroup(CreateGroup data) async {
  final String url =
      "${GlobalConfiguration().getString("api_base_url")}update_group";
  print("$url");
  var token = "";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(Constant.TOKEN)) {
    token = prefs.getString(Constant.TOKEN)!;
  }

  Uri myUri = Uri.parse(url);
  var request = new http.MultipartRequest("POST", myUri);
  Map<String, String> headers = {
    HttpHeaders.authorizationHeader: 'Bearer $token'
  };
  request.headers.addAll(headers);
  request.fields['group_id'] = data.group_id;
  request.fields['name'] = data.group_name;
  request.fields['about'] = data.about;

  if (data.group_img != null) {
    String fileName = data.group_img!.path.split("/").last;
    var stream =
        new http.ByteStream(DelegatingStream.typed(data.group_img!.openRead()));
    var length = await data.group_img!.length();
    var multipartFileSign =
        new http.MultipartFile('group_img', stream, length, filename: fileName);
    request.files.add(multipartFileSign);
  }
  request.fields.forEach((key, value) {
    print("${key} : ${value}");
  });
  CreateGroup returnData = new CreateGroup();
  http.Response response = await http.Response.fromStream(await request.send());
  print("Result: ${response.body}");
  var res = json.decode(response.body);
  if (res['success']) {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(data.group_id)
        .update({"group_name": data.group_name, "group_topic": data.about});
    print("update to thay 6e");
    returnData.error = res['message'];
    returnData.isDone = true;
  } else {
    returnData.error = res['message'];
    returnData.isDone = false;
  }
  return returnData;
}

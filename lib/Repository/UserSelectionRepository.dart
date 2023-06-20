import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Models/FriendUser.dart';
import 'package:neuro/Models/Group.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<FriendUser>> getFriendList(FriendUser data) async {
  final String url = "${GlobalConfiguration().get("api_base_url")}user_list";
  print("$url");
  Uri myUri = Uri.parse(url);
  var token = "";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(Constant.TOKEN)) {
    token = prefs.getString(Constant.TOKEN)!;
  }
  print(token);
  final client = new http.Client();
  final response = await client.post(myUri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: json.encode(data.toMap()));
  List<FriendUser> returnData = <FriendUser>[];
  if (response.statusCode == 200) {
    print(response.body.toString());
    var res = json.decode(response.body);
    if (res['success']) {
      returnData =
          (res['data'] as List).map((e) => FriendUser.fromJSON(e)).toList();
    }
  } else {
    print(response.body.toString());
  }
  return returnData;
}

Future<bool> addRemoveGroup(Group data) async {
  final String url =
      "${GlobalConfiguration().get("api_base_url")}group_member_add";
  print("$url");
  Uri myUri = Uri.parse(url);
  var token = "";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(Constant.TOKEN)) {
    token = prefs.getString(Constant.TOKEN)!;
  }
  print(token);
  final client = new http.Client();
  final response = await client.post(myUri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: json.encode(data.toMapAddRemove()));

  if (response.statusCode == 200) {
    print(response.body.toString());
    var res = json.decode(response.body);
    if (res['success']) {
      return true;
    }
    return false;
  } else {
    print(response.body.toString());
  }
  return false;
}

import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Models/Matches.dart';
import 'package:neuro/Models/NeuroRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Matches>> getMatches() async {
  final String url = "${GlobalConfiguration().get("api_base_url")}match_list";
  print("$url");
  Uri myUri = Uri.parse(url);
  var token = "";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(Constant.TOKEN)) {
    token = prefs.getString(Constant.TOKEN)!;
  }
  print(token);
  final client = new http.Client();
  final response = await client.get(
    myUri,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    },
  );
  List<Matches> returnData = <Matches>[];
  if (response.statusCode == 200) {
    print(response.body.toString());
    var res = json.decode(response.body);
    if (res['success']) {
      returnData =
          (res['data'] as List).map((e) => Matches.fromJSON(e)).toList();
    }
  } else {
    print(response.body.toString());
  }
  return returnData;
}

Future<bool> removeMatches(NeuroRequest data) async {
  final String url =
      "${GlobalConfiguration().get("api_base_url")}remove_user_match";
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
      body: json.encode(data.toMap()));
  print(data.toMap());
  if (response.statusCode == 200) {
    print(response.body.toString());
  } else {
    print(response.body.toString());
  }
  return true;
}

Future<bool> sendNotification(Map data) async {
  final String url = "https://fcm.googleapis.com/fcm/send";
  print("$url");
  Uri myUri = Uri.parse(url);
  final client = new http.Client();
  final response = await client.post(myUri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'key=${Constant.SERVERKEY}'
      },
      body: json.encode(data));
  print(data);
  if (response.statusCode == 200) {
    print(response.body.toString());
    var res = json.decode(response.body);
    if (res['success'] == true) {
      return true;
    }
  } else {
    print(response.body.toString());
  }
  return false;
}

import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Models/Feed.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Feed> getFeeds(Feed data) async {
  final String url = "${GlobalConfiguration().get("api_base_url")}feeds";
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
  print(data.toMap());
  Feed returnData = Feed();
  if (response.statusCode == 200) {
    print(response.body.toString());
    var res = json.decode(response.body);
    if (res['success']) {
      returnData.list_feeds =
          (res['data']['feeds'] as List).map((e) => Feed.fromJSON(e)).toList();
      returnData.isNext = res['data']['isNext'];
    }
  } else {
    print(response.body.toString());
  }
  return returnData;
}

Future<bool> feedSwipe(Feed data) async {
  final String url =
      "${GlobalConfiguration().get("api_base_url")}user_send_request";
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
      body: json.encode(data.toMapSwipe()));
  print(data.toMapSwipe());
  if (response.statusCode == 200) {
    print(response.body.toString());
    var res = json.decode(response.body);
    if (res['success']) {
      bool isNext = res['data']['isNext'];
      return isNext;
    } else {
      return false;
    }
  } else {
    print(response.body.toString());
    return false;
  }
}

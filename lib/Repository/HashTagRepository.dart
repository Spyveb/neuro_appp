import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Models/HashTag.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<HashTag>> hasTagList() async {
  final String url = "${GlobalConfiguration().get("api_base_url")}hashtag";
  print("$url");
  Uri myUri = Uri.parse(url);
  var token = "";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(Constant.TOKEN)) {
    token = prefs.getString(Constant.TOKEN)!;
  }
  final client = new http.Client();
  final response = await client.get(
    myUri,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    },
  );
  List<HashTag> returnData = <HashTag>[];
  if (response.statusCode == 200) {
    print(response.body.toString());
    var res = json.decode(response.body);
    if (res['success']) {
      returnData =
          (res['data'] as List).map((e) => HashTag.fromJSON(e)).toList();
    }
  } else {
    print(response.body.toString());
  }
  return returnData;
}

Future<HashTag> addHashTag(HashTag data) async {
  final String url = "${GlobalConfiguration().get("api_base_url")}add_hashtag";
  print("$url");
  Uri myUri = Uri.parse(url);
  final client = new http.Client();
  final response = await client.post(myUri,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(data.toMap()));
  print(data.toMap());
  print(response.body.toString());
  HashTag returnData = new HashTag();
  if (response.statusCode == 200) {
    print(response.body.toString());
    var res = json.decode(response.body);
    if (res['success']) {
      Map<String, dynamic> hashData = res['data'];
      returnData.name = hashData['name'].toString();
      returnData.id = hashData['id'].toString();
      returnData.isSelected = true;
    }
  } else if (response.statusCode == 404) {
    var res = json.decode(response.body);
    returnData.message = res['message'].toString();
    print(response.body.toString());
  }
  return returnData;
}

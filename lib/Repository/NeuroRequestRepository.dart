import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Models/NeuroRequest.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<NeuroRequest>> getNeuroRequestList() async {
  final String url = "${GlobalConfiguration().get("api_base_url")}receiver_request_list";
  print("$url");
  var token = "";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(Constant.TOKEN)) {
    token = prefs.getString(Constant.TOKEN)!;
  }
  Uri myUri = Uri.parse(url);
  final client = new http.Client();
  final response = await client.get(
    myUri,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    },
  );
  List<NeuroRequest> returnData = <NeuroRequest>[];
  if (response.statusCode == 200) {
    print(response.body.toString());
    var res = json.decode(response.body);
    if (res['success']) {
      returnData =
          (res['data'] as List).map((e) => NeuroRequest.fromJSON(e)).toList();
    }
  } else {
    print(response.body.toString());
  }
  return returnData;
}

Future<bool> acceptrejectRequest(NeuroRequest data) async {
  final String url = "${GlobalConfiguration().get("api_base_url")}accept_request";
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


import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Models/Nudge.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Nudge> buyNudge() async {
  final String url = "${GlobalConfiguration().get("api_base_url")}budge_buy";
  print("$url");
  Nudge data = new Nudge();
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
  Nudge returnData = new Nudge();
  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    if (res['success']) {
      returnData.message = res['message'];
      returnData.isDone = true;
    } else {
      returnData.message = res['message'];
      returnData.isDone = false;
    }
    print(response.body.toString());
  } else {
    var res = json.decode(response.body);
    returnData.message = res['message'];
    returnData.isDone = false;
    print(response.body.toString());
  }
  return returnData;
}

import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Models/NotificationL.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<NotificationL> notifcationStatusChange(NotificationL data) async {
  final String url = "${GlobalConfiguration().get("api_base_url")}notification";
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
  NotificationL returnData = new NotificationL();
  if (response.statusCode == 200) {
    print(response.body.toString());
  } else {
    print(response.body.toString());
  }
  return returnData;
}

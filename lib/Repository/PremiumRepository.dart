import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Models/Premium.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Premium> premiumStatusChange(Premium data) async {
  final String url =
      "${GlobalConfiguration().get("api_base_url")}change_status";
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
  Premium returnData = new Premium();
  if (response.statusCode == 200) {
    print(response.body.toString());
    await prefs.setBool(Constant.ISPRIME, true);
  } else {
    print(response.body.toString());
  }
  return returnData;
}

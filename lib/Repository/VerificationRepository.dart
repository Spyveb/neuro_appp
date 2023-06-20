import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Models/Verification.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> passVerification(Verification data) async {
  final String url =
      "${GlobalConfiguration().getString("api_base_url")}varificationRequest";
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
  request.fields['type'] = data.type;

  if (data.file != null) {
    String fileName = data.file!.path.split("/").last;
    var stream =
        new http.ByteStream(DelegatingStream.typed(data.file!.openRead()));
    var length = await data.file!.length();
    var multipartFileSign =
        new http.MultipartFile('image', stream, length, filename: fileName);
    request.files.add(multipartFileSign);
  }

  http.Response response = await http.Response.fromStream(await request.send());
  print("Result: ${response.body}");
  var res = json.decode(response.body);
  if (res['success']) {
    return true;
  } else {
    return false;
  }
}

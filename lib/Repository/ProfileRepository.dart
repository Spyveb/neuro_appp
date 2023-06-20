import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Models/EditProfile.dart';
import 'package:neuro/Models/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Profile> getProfile(Profile data) async {
  final String url = "${GlobalConfiguration().get("api_base_url")}user_detail";
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
  Profile returnData = Profile();
  if (response.statusCode == 200) {
    print(response.body.toString());
    var res = json.decode(response.body);
    if (res['success']) {
      returnData = Profile.fromJSON(res['data']);
    }
  } else {
    print(response.body.toString());
  }
  return returnData;
}

Future<EditProfile> editProfile(EditProfile data) async {
  final String url =
      "${GlobalConfiguration().getString("api_base_url")}update_profile";
  print("$url");
  var token = "";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(Constant.TOKEN)) {
    token = prefs.getString(Constant.TOKEN)!;
  }

  EditProfile returnData = new EditProfile();
  Uri myUri = Uri.parse(url);
  var request = new http.MultipartRequest("POST", myUri);
  Map<String, String> headers = {
    HttpHeaders.authorizationHeader: 'Bearer $token'
  };
  request.headers.addAll(headers);
  request.fields['name'] = data.name;
  request.fields['email'] = data.email;
  //request.fields['age'] = data.age;
  request.fields['gender'] = data.gender;

  //request.fields['following_applies'] = data.following_applies;
  request.fields['mode'] = data.mode;
  request.fields['neurologicalstatus'] = data.neurologicalstatus;
  request.fields['about_me'] = data.about_me;
  request.fields['old_image'] = data.old_image;
  request.fields['personality'] = data.personality;
  if (data.profile_imge != null) {
    String fileName = data.profile_imge!.path.split("/").last;
    var stream = new http.ByteStream(
        DelegatingStream.typed(data.profile_imge!.openRead()));
    var length = await data.profile_imge!.length();
    var multipartFileSign = new http.MultipartFile(
        'profile_img', stream, length,
        filename: fileName);
    request.files.add(multipartFileSign);
  }

  for (var file in data.more_new_image) {
    String fileName = file.path.split("/").last;
    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    var multipartFileSign =
        new http.MultipartFile('files[]', stream, length, filename: fileName);
    request.files.add(multipartFileSign);
  }
  request.fields.forEach((key, value) {
    print("$key $value");
  });

  http.Response response = await http.Response.fromStream(await request.send());
  print("Result: ${response.body}");
  var res = json.decode(response.body);
  if (res['success']) {
    await prefs.setString(Constant.MODE, data.mode);
    returnData.error = res['message'];
    returnData.isDone = true;
  } else {
    returnData.error = res['message'];
    returnData.isDone = false;
  }
  return returnData;
}

Future<EditProfile> editNeuroStatushashtag(EditProfile data) async {
  final String url =
      "${GlobalConfiguration().getString("api_base_url")}update_profile";
  print("$url");
  var token = "";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(Constant.TOKEN)) {
    token = prefs.getString(Constant.TOKEN)!;
  }

  EditProfile returnData = new EditProfile();
  Uri myUri = Uri.parse(url);
  var request = new http.MultipartRequest("POST", myUri);
  Map<String, String> headers = {
    HttpHeaders.authorizationHeader: 'Bearer $token'
  };
  request.headers.addAll(headers);
  request.fields['following_applies'] = data.following_applies;
  request.fields['neurologicalstatus'] = "Neurodivergent";
  http.Response response = await http.Response.fromStream(await request.send());
  print("Result: ${response.body}");
  var res = json.decode(response.body);
  if (res['success']) {
    returnData.error = res['message'];
    returnData.isDone = true;
  } else {
    returnData.error = res['message'];
    returnData.isDone = false;
  }
  return returnData;
}

Future<EditProfile> editNeuroStatus(EditProfile data) async {
  final String url =
      "${GlobalConfiguration().getString("api_base_url")}update_profile";
  print("$url");
  var token = "";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(Constant.TOKEN)) {
    token = prefs.getString(Constant.TOKEN)!;
  }

  EditProfile returnData = new EditProfile();
  Uri myUri = Uri.parse(url);
  var request = new http.MultipartRequest("POST", myUri);
  Map<String, String> headers = {
    HttpHeaders.authorizationHeader: 'Bearer $token'
  };
  request.headers.addAll(headers);
  request.fields['neurologicalstatus'] = data.neurologicalstatus;
  http.Response response = await http.Response.fromStream(await request.send());
  print("Result: ${response.body}");
  var res = json.decode(response.body);
  if (res['success']) {
    returnData.error = res['message'];
    returnData.isDone = true;
  } else {
    returnData.error = res['message'];
    returnData.isDone = false;
  }
  return returnData;
}


Future<bool> logout() async {
  final String url = "${GlobalConfiguration().getString("api_base_url")}logout";
  print("$url");
  var token = "";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(Constant.TOKEN)) {
    token = prefs.getString(Constant.TOKEN)!;
  }

  EditProfile returnData = new EditProfile();
  Uri myUri = Uri.parse(url);
  print(token);
  final client = new http.Client();
  final response = await client.post(
    myUri,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    },
  );
  print(response.body.toString());
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> deleteaccount() async {
  final String url =
      "${GlobalConfiguration().getString("api_base_url")}delete_user";
  print("$url");
  var token = "";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(Constant.TOKEN)) {
    token = prefs.getString(Constant.TOKEN)!;
  }

  EditProfile returnData = new EditProfile();
  Uri myUri = Uri.parse(url);
  print(token);
  final client = new http.Client();
  final response = await client.post(
    myUri,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    },
  );
  print(response.body.toString());
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<Profile> editMode(Profile data) async {
  final String url = "${GlobalConfiguration().get("api_base_url")}edit_user_field";
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
      body: json.encode(data.toMapMode()));
  Profile returnData = Profile();
  if (response.statusCode == 200) {
    print(response.body.toString());
    var res = json.decode(response.body);
    if (res['success']) {
      await prefs.setString(Constant.MODE, data.mode);
    }
  } else {
    print(response.body.toString());
  }
  return returnData;
}

Future<Profile> editLocation(Profile data) async {
  final String url = "${GlobalConfiguration().get("api_base_url")}update_user_data";
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
      body: json.encode(data.toMapLocation()));
  Profile returnData = Profile();
  if (response.statusCode == 200) {
    print(response.body.toString());
    var res = json.decode(response.body);
    if (res['success']) {

    }
  } else {
    print(response.body.toString());
  }
  return returnData;
}

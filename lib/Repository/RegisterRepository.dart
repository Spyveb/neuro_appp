import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Helper/FirebaseManager.dart';
import 'package:neuro/Helper/FirebaseMessages.dart';
import 'package:neuro/Helper/PaymentService.dart';
import 'package:neuro/Models/Register.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Register> userRegister(Register data) async {
  final String url =
      "${GlobalConfiguration().getString("api_base_url")}register";
  print("$url");
  Register returnData = new Register();
  Uri myUri = Uri.parse(url);
  SharedPreferences pref = await SharedPreferences.getInstance();
  var request = new http.MultipartRequest("POST", myUri);
  request.fields['latitude'] = data.latitude;
  request.fields['longitude'] = data.longitude;
  request.fields['address'] = data.address;
  request.fields['name'] = data.name;
  request.fields['email'] = data.email;
  request.fields['password'] = data.password;
  request.fields['birthdate'] = data.dob;
  request.fields['gender'] = data.gender;
  if (data.neurologicalstatus.toUpperCase() != "Neurotypical".toUpperCase()) {
    request.fields['following_applies'] = data.following_applies;
  }
  request.fields['mode'] = data.mode;
  request.fields['about_me'] = data.about;
  request.fields['deviceToken'] = FirebaseMessages().fcmToken;
  request.fields['personality'] = data.personality;
  request.fields['neurologicalstatus'] = data.neurologicalstatus;
  if (data.social_id.isNotEmpty) {
    request.fields['social_id'] = data.social_id;
  }

  if (data.profile != null) {
    String fileName = data.profile!.path.split("/").last;
    var stream =
        new http.ByteStream(DelegatingStream.typed(data.profile!.openRead()));
    var length = await data.profile!.length();
    var multipartFileSign = new http.MultipartFile(
        'profile_img', stream, length,
        filename: fileName);
    request.files.add(multipartFileSign);
  }

  for (var file in data.moreimages) {
    String fileName = file.path.split("/").last;
    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    var multipartFileSign =
        new http.MultipartFile('files[]', stream, length, filename: fileName);
    request.files.add(multipartFileSign);
  }
  print(request.fields);

  http.Response response = await http.Response.fromStream(await request.send());
  print("Result: ${response.body}");
  var res = json.decode(response.body);
  if (res['success']) {
    Map<String, dynamic> userData = res['data'];
    pref.setString(Constant.TOKEN, userData['token']);
    pref.setString(Constant.USERID, userData['user']['id'].toString());
    pref.setString(Constant.NAME, userData['user']['name'].toString());
    pref.setString(Constant.EMAIL, userData['user']['email'].toString());
    pref.setString(
        Constant.PROFILEIMAGE, userData['user']['profile_img'].toString());
    pref.setString(
        Constant.NOTIFICATION, userData['user']['notification'].toString());
    pref.setBool(Constant.ISPRIME, userData['user']['isPrime']);
    pref.setString(Constant.MODE, userData['user']['mode']);
    pref.setBool(Constant.ISLOGIN, true);

    FirebaseFirestore.instance
        .collection('users')
        .doc(userData['user']['id'].toString())
        .set({
      'nickname': userData['user']['name'].toString(),
      'photoUrl': userData['user']['profile_img'].toString(),
      'id': userData['user']['id'].toString(),
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
      'chattingWith': null,
      'deviceToken': FirebaseMessages().fcmToken,
    });
    FirebaseManager().getUserList();
    PaymentService().initConnection();
    returnData.error = res['message'];
    returnData.isDone = true;
  } else {
    pref.setBool(Constant.ISLOGIN, false);
    returnData.error = res['message'];
    returnData.isDone = false;
  }
  return returnData;
}

Future<Register> userLogin(Register data) async {
  final String url = "${GlobalConfiguration().get("api_base_url")}login";
  print("$url");
  Uri myUri = Uri.parse(url);
  SharedPreferences pref = await SharedPreferences.getInstance();
  final client = new http.Client();
  final response = await client.post(myUri,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(data.toMap()));
  print(data.toMap());
  Register returnData = new Register();
  if (response.statusCode == 200) {
    print(response.body.toString());
    var res = json.decode(response.body);
    if (res['success']) {
      Map<String, dynamic> userData = res['data'];
      pref.setString(Constant.TOKEN, userData['token']);
      pref.setString(Constant.USERID, userData['id'].toString());
      pref.setString(Constant.NAME, userData['name'].toString());
      pref.setString(Constant.EMAIL, userData['email'].toString());
      pref.setString(Constant.PROFILEIMAGE, userData['profile_img'].toString());
      pref.setString(
          Constant.NOTIFICATION, userData['notification'].toString());
      pref.setBool(Constant.ISPRIME, userData['isPrime']);
      pref.setString(Constant.MODE, userData['mode']);
      pref.setBool(Constant.ISLOGIN, true);
      FirebaseFirestore.instance
          .collection('users')
          .doc(userData['id'].toString())
          .set({
        'nickname': userData['name'].toString(),
        'photoUrl': userData['profile_img'].toString(),
        'id': userData['id'].toString(),
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        'chattingWith': null,
        'deviceToken': FirebaseMessages().fcmToken,
      });
      FirebaseManager().getUserList();
      returnData.error = res['message'];
      returnData.isDone = true;
    } else {
      pref.setBool(Constant.ISLOGIN, false);
      returnData.error = res['message'];
      returnData.isDone = false;
    }
  } else {
    var res = json.decode(response.body);
    pref.setBool(Constant.ISLOGIN, false);
    returnData.error = res['message'];
    returnData.isDone = false;
  }
  return returnData;
}

Future<Register> userEmailCheck(Register data) async {
  final String url = "${GlobalConfiguration().get("api_base_url")}gmail_check";
  print("$url");
  Uri myUri = Uri.parse(url);
  SharedPreferences pref = await SharedPreferences.getInstance();
  final client = new http.Client();
  final response = await client.post(myUri,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(data.toEmailCheckMap()));
  print(data.toEmailCheckMap());
  Register returnData = new Register();
  if (response.statusCode == 200) {
    print(response.body.toString());
    var res = json.decode(response.body);
    if (res['success']) {
      returnData.error = res['message'];
      returnData.isDone = true;
    } else {
      returnData.error = res['message'];
      returnData.isDone = false;
    }
  } else {
    var res = json.decode(response.body);
    returnData.error = res['message'];
    returnData.isDone = false;
  }
  return returnData;
}

Future<Register> userSociallogin(Register data) async {
  final String url = "${GlobalConfiguration().get("api_base_url")}sociallogin";
  print("$url");
  Uri myUri = Uri.parse(url);
  SharedPreferences pref = await SharedPreferences.getInstance();
  final client = new http.Client();
  final response = await client.post(myUri,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(data.toMapSocial()));
  print(data.toMapSocial());
  Register returnData = new Register();
  if (response.statusCode == 200) {
    print(response.body.toString());
    var res = json.decode(response.body);
    if (res['success']) {
      Map<String, dynamic> userData = res['data'];
      pref.setString(Constant.TOKEN, userData['token']);
      await pref.setString(Constant.USERID, userData['id'].toString());
      pref.setString(Constant.NAME, userData['name'].toString());
      pref.setString(Constant.EMAIL, userData['email'].toString());
      pref.setString(Constant.PROFILEIMAGE, userData['profile_img'].toString());
      pref.setBool(Constant.ISPRIME, userData['isPrime']);
      if (userData['mode'] != null) {
        pref.setString(Constant.MODE, userData['mode']);
      }
      pref.setString(
          Constant.NOTIFICATION, userData['notification'].toString());
      pref.setBool(Constant.ISLOGIN, true);
      FirebaseFirestore.instance
          .collection('users')
          .doc(userData['id'].toString())
          .set({
        'nickname': userData['name'].toString(),
        'photoUrl': userData['profile_img'].toString(),
        'id': userData['id'].toString(),
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        'chattingWith': null,
        'deviceToken': FirebaseMessages().fcmToken,
      });
      FirebaseManager().getUserList();
      returnData.error = res['message'];
      returnData.isDone = true;
    } else {
      pref.setBool(Constant.ISLOGIN, false);
      returnData.error = res['message'];
      returnData.isDone = false;
    }
  } else {
    var res = json.decode(response.body);
    pref.setBool(Constant.ISLOGIN, false);
    returnData.error = res['message'];
    returnData.isDone = false;
  }
  return returnData;
}

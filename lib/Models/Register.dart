import 'dart:io';

class Register {
  String name = "";
  String email = "";
  String password = "";
  String deviceToken = "";
  String dob = "";
  String gender = "";
  String following_applies = "";
  String mode = "";
  String latitude = "";
  String longitude = "";
  String address = "";
  File? profile;
  List<File> moreimages = <File>[];
  String about = "";

  String error = "";
  bool isDone = false;

  String type = "";

  String gmail = "";

  String social_id = "";
  String personality = "";

  String neurologicalstatus = "";

  Register();

  @override
  String toString() {
    return 'Register{name: $name, email: $email, password: $password, dob: $dob, gender: $gender, following_applies: $following_applies, mode: $mode, latitude: $latitude, longitude: $longitude, address: $address, profile: $profile, moreimages: $moreimages}';
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['email'] = email;
    map['password'] = password;
    map['deviceToken'] = deviceToken;
    return map;
  }

  Map toMapSocial() {
    var map = new Map<String, dynamic>();
    map['emailId'] = email;
    map['registerType'] = type;
    map['social_id'] = social_id;
    map['deviceToken'] = deviceToken;
    return map;
  }

  Map toEmailCheckMap() {
    var map = new Map<String, dynamic>();
    map['gmail'] = gmail;
    return map;
  }
}

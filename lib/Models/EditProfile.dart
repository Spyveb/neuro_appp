import 'dart:io';

class EditProfile {
  String name = "";
  String email = "";
  String age = "";
  String about_me = "";
  String gender = "";
  String mode = "";
  String following_applies = "";
  String old_image = "";
  String personality ="";
  File? profile_imge;
  String neurologicalstatus = "";
  List<File> more_new_image = <File>[];

  String error = "";
  bool isDone = false;

  EditProfile();
}

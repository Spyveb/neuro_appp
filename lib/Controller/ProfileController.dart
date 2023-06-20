import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Dummy.dart';
import 'package:neuro/Models/EditProfile.dart';
import 'package:neuro/Models/HashTag.dart';
import 'package:neuro/Models/NotificationL.dart';
import 'package:neuro/Models/Profile.dart';
import 'package:neuro/Repository/HashTagRepository.dart' as repoHash;
import 'package:neuro/Repository/NotificationRepository.dart'
    as repoNotification;
import 'package:neuro/Repository/ProfileRepository.dart' as repoProfile;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends ControllerMVC {
  late GlobalKey<ScaffoldState> scaffoldKey;
  late OverlayEntry loader;
  Profile data = Profile();
  Profile sendData = Profile();
  bool isNotification = true;
  NotificationL sendNotificationData = new NotificationL();
  List<HashTag> list_hash = <HashTag>[];
  double widthCustom = 0.0;
  List<Dummy> list_images_personality = [
    new Dummy("Adventurous", false),
    new Dummy("Animal_lover", false),
    new Dummy("Artsy", false),
    new Dummy("Athletic", false),
    new Dummy("Bookworm", false),
    new Dummy("Coffee_addict", false),
    new Dummy("Divorcee", false),
    new Dummy("DIY", false),
    new Dummy("Engaged", false),
    new Dummy("Entrepreneurial", false),
    new Dummy("Extravert", false),
    new Dummy("Film_fan", false),
    new Dummy("Foodie", false),
    new Dummy("Gamer", false),
    new Dummy("Homebody", false),
    new Dummy("Hopeless_romantic", false),
    new Dummy("Introvert", false),
    new Dummy("Jetsetter", false),
    new Dummy("LGBTQI", false),
    new Dummy("Married", false),
    new Dummy("Messy", false),
    new Dummy("Music_lover", false),
    new Dummy("Neat_and_tidy", false),
    new Dummy("Party_animal", false),
    new Dummy("Perfectionist", false),
    new Dummy("Performing_arts", false),
    new Dummy("Sci_fi_enthusiast", false),
    new Dummy("Shopaholic", false),
    new Dummy("Single_parent_2", false),
    new Dummy("Student", false),
    new Dummy("veggie", false),
    new Dummy("Volunteer", false),
    new Dummy("Witchy_vibes", false),
    new Dummy("Yogi", false),
  ];

  ProfileController(bool isCall) {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    loader = Helper.overlayLoader(this.scaffoldKey.currentContext);
    if (isCall) {
      Future.delayed(const Duration(milliseconds: 300), () {
        getProfile();
      });
    }
  }

  void editProfile(EditProfile sendData) async {
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoProfile
                  .editProfile(sendData)
                  .then((value) => {
                        loader.remove(),
                        if (value.isDone)
                          {
                            Helper.showToast(value.error),
                            Navigator.pop(
                                this.scaffoldKey.currentContext!, "1"),
                          }
                        else
                          {
                            Helper.showToast(value.error),
                          },
                      })
                  .catchError((e) {
                print(e);
                Helper.showToast("Something went wrong");
              }).whenComplete(() {
                Helper.hideLoader(loader);
              })
            }
          else
            {
              loader.remove(),
              Helper.showToast("No Internet Connection"),
            }
        });
  }

  double widthCustomName = 0.0;

  void getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sendData.id = prefs.getString(Constant.USERID)!;
    Size textSize;
    /*FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);*/
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoProfile
                  .getProfile(sendData)
                  .then((value) async => {
                        data = value,
                        await prefs.setString(
                            Constant.NAME, value.name.toString()),
                        await prefs.setString(Constant.PROFILEIMAGE,
                            value.profile_img.toString()),
                        await prefs.setString(Constant.MODE, value.mode),
                        isNotification =
                            value.notification == "1" ? true : false,
                        textSize = Helper.textSize(
                            "${value.name}, ${value.birthdate}",
                            TextStyle(
                                fontSize: getProportionalFontSize(30),
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        if (textSize.width >
                            (MediaQuery.of(this.scaffoldKey.currentContext!)
                                    .size
                                    .width *
                                0.60))
                          {
                            widthCustomName =
                                MediaQuery.of(this.scaffoldKey.currentContext!)
                                        .size
                                        .width *
                                    0.55,
                          }
                        else
                          {
                            widthCustomName = textSize.width,
                          },
                        setState(() {}),
                        //loader.remove(),
                      })
                  .catchError((e) {
                print(e);
                Helper.showToast("Something went wrong");
              }).whenComplete(() {
                // Helper.hideLoader(loader);
              })
            }
          else
            {
              // loader.remove(),
              Helper.showToast("No Internet Connection"),
            }
        });
  }

  void updateNotifcationStatus() async {
    /*FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);*/
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoNotification
                  .notifcationStatusChange(this.sendNotificationData)
                  .then((value) => {
                        //  loader.remove(),
                      })
                  .catchError((e) {
                print(e);
                Helper.showToast("Something went wrong");
              }).whenComplete(() {
                // Helper.hideLoader(loader);
              })
            }
          else
            {
              //loader.remove(),
              Helper.showToast("No Internet Connection"),
            }
        });
  }

  void getHashTagList3(List<dynamic> split) async {
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    var data = StringBuffer();
    Size textSize;
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoHash
                  .hasTagList()
                  .then((value) => {
                        list_hash.clear(),
                        list_hash.addAll(value),
                        list_hash.forEach((elementMain) {
                          if (split.contains(elementMain.name)) {
                            elementMain.isSelected = true;
                          }
                        }),
                        value.forEach((element) {
                          data.write(element.name);
                        }),
                        textSize = Helper.textSize(
                            data.toString().toUpperCase(),
                            TextStyle(
                              fontSize: getProportionalFontSize(10),
                              fontFamily: 'poppins',
                            )),
                        getNewWidth3(
                            value, (textSize.width + (value.length * 62)) / 8),
                        setState(() {}),
                        loader.remove(),
                      })
                  .catchError((e) {
                print(e);
                Helper.showToast("Something went wrong");
              }).whenComplete(() {
                Helper.hideLoader(loader);
              })
            }
          else
            {
              loader.remove(),
              Helper.showToast("No Internet Connection"),
            }
        });
  }

  void getNewWidth3(List<HashTag> value, double NewwidthCustom) {
    double x = 0.0;
    int row = 0;
    value.forEach((element) {
      x += 24 +
          (Helper.textSize(
              element.name.toUpperCase(),
              TextStyle(
                fontSize: getProportionalFontSize(10),
                fontFamily: 'poppins',
              ))).width +
          24 +
          14;
      if (x > NewwidthCustom) {
        x = 24 +
            (Helper.textSize(
                element.name.toUpperCase(),
                TextStyle(
                  fontSize: getProportionalFontSize(10),
                  fontFamily: 'poppins',
                ))).width +
            24 +
            14;
        row++;
      }
    });
    if (row >= 3) {
      print(row);
      getNewWidth3(value, NewwidthCustom + 2);
    } else {
      print("else$row");
      widthCustom = NewwidthCustom;
      print(widthCustom);
      setState(() {});
    }
  }

  void logout() async {
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    SharedPreferences pref = await SharedPreferences.getInstance();
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoProfile
                  .logout()
                  .then((value) async => {
                        loader.remove(),
                        await pref.clear(),
                        Navigator.of(this.scaffoldKey.currentContext!)
                            .pushNamedAndRemoveUntil(
                                '/Login', (Route<dynamic> route) => false),
                        Helper.showToast("Successfully Logout"),
                      })
                  .catchError((e) {
                print(e);
                Helper.showToast("Something went wrong");
              }).whenComplete(() {
                Helper.hideLoader(loader);
              })
            }
          else
            {
              loader.remove(),
              Helper.showToast("No Internet Connection"),
            }
        });
  }

  void deleteaccount() async {
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    SharedPreferences pref = await SharedPreferences.getInstance();
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoProfile
                  .deleteaccount()
                  .then((value) async => {
                        loader.remove(),
                        await pref.clear(),
                        Navigator.of(this.scaffoldKey.currentContext!)
                            .pushNamedAndRemoveUntil(
                                '/Login', (Route<dynamic> route) => false),
                        Helper.showToast("Account Deleted Successfully"),
                      })
                  .catchError((e) {
                print(e);
                Helper.showToast("Something went wrong");
              }).whenComplete(() {
                Helper.hideLoader(loader);
              })
            }
          else
            {
              loader.remove(),
              Helper.showToast("No Internet Connection"),
            }
        });
  }

  void editMode(Profile sendData) async {
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoProfile
                  .editMode(sendData)
                  .then((value) => {
                        Helper.showToast("Mode successfully upgraded"),
                        loader.remove(),
                      })
                  .catchError((e) {
                print(e);
                Helper.showToast("Something went wrong");
              }).whenComplete(() {
                Helper.hideLoader(loader);
              })
            }
          else
            {
              loader.remove(),
              Helper.showToast("No Internet Connection"),
            }
        });
  }

  void editLocation(Profile sendData) async {
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoProfile
                  .editLocation(sendData)
                  .then((value) => {
                        Helper.showToast("Location successfully upgraded"),
                        loader.remove(),
                      })
                  .catchError((e) {
                print(e);
                Helper.showToast("Something went wrong");
              }).whenComplete(() {
                Helper.hideLoader(loader);
              })
            }
          else
            {
              loader.remove(),
              Helper.showToast("No Internet Connection"),
            }
        });
  }
}

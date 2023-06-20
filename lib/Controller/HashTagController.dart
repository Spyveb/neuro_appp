import 'dart:async' show Future;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/GradientPainter.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/EditProfile.dart';
import 'package:neuro/Models/HashTag.dart';
import 'package:neuro/Models/Register.dart';
import 'package:neuro/Models/route_arguments.dart';
import 'package:neuro/Repository/HashTagRepository.dart' as repoHash;
import 'package:neuro/Repository/ProfileRepository.dart' as repoProfile;
import 'package:neuro/Repository/RegisterRepository.dart' as repoRegister;
import 'package:neuro/main.dart';

class HashTagController extends ControllerMVC {
  late GlobalKey<ScaffoldState> scaffoldKey;
  late OverlayEntry loader;
  List<HashTag> list_hash = <HashTag>[];
  double widthCustom = 0.0;
  var tyepHashtagCon = TextEditingController();
  HashTag sendData = new HashTag();
  Register sendRegister = new Register();

  HashTagController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    loader = Helper.overlayLoader(this.scaffoldKey.currentContext);
    loadAsset();
  }

  void getHashTagList({List<dynamic>? following_applies}) async {
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
                        if (following_applies != null &&
                            following_applies.length > 0)
                          {
                            list_hash.forEach((elementMain) {
                              if (following_applies.contains(
                                      elementMain.name.toUpperCase()) ||
                                  following_applies.contains(
                                      elementMain.name.toLowerCase()) ||
                                  following_applies
                                      .contains(elementMain.name)) {
                                elementMain.isSelected = true;
                              }
                            }),
                          },
                        value.forEach((element) {
                          data.write(element.name);
                        }),
                        textSize = Helper.textSize(
                            data.toString().toUpperCase(),
                            TextStyle(
                              fontSize: getProportionalFontSize(10),
                              fontFamily: 'poppins',
                              letterSpacing: 1.68,
                            )),
                        getNewWidth(
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

  void getNewWidth(List<HashTag> value, double NewwidthCustom) {
    double x = 0.0;
    int row = 0;
    value.forEach((element) {
      x += 24 +
          (Helper.textSize(
              element.name.toUpperCase(),
              TextStyle(
                fontSize: getProportionalFontSize(10),
                fontFamily: 'poppins',
                letterSpacing: 1.68,
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
                  letterSpacing: 1.68,
                ))).width +
            24 +
            14;
        row++;
      }
    });
    var totalRows = (MediaQuery.of(scaffoldKey.currentContext!).size.height -
        (MediaQuery.of(scaffoldKey.currentContext!).padding.top +
            kToolbarHeight) -
        281);
    totalRows = (totalRows / 50);
    if (row >= totalRows.toInt()) {
      print(row);
      getNewWidth(value, NewwidthCustom + 2);
    } else {
      print(row);
      widthCustom = NewwidthCustom;
      print(widthCustom);
      setState(() {});
    }
  }

  void addHashtag() async {
    var data = StringBuffer();
    Size textSize;
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoHash
                  .addHashTag(this.sendData)
                  .then((value) => {
                        if (value.message != "")
                          {
                            Helper.showToast(value.message),
                          }
                        else
                          {
                            print(value.toString()),
                            tyepHashtagCon.clear(),
                            list_hash = [value, ...list_hash],
                            setState(() {}),
                            list_hash.forEach((element) {
                              data.write(element.name);
                            }),
                            textSize = Helper.textSize(
                                data.toString().toUpperCase(),
                                TextStyle(
                                  fontSize: getProportionalFontSize(10),
                                  fontFamily: 'poppins',
                                  letterSpacing: 1.68,
                                )),
                            getNewWidth(list_hash,
                                (textSize.width + (list_hash.length * 62)) / 8),
                          },
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

  void userRegister() async {
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoRegister
                  .userRegister(this.sendRegister)
                  .then((value) => {
                        if (value.isDone)
                          {
                            Helper.showToast(value.error),
                            /*Navigator.pop(this.scaffoldKey.currentContext!),
                            Navigator.pushNamedAndRemoveUntil(
                                this.scaffoldKey.currentContext!,
                                '/Dashboard',
                                (route) => false),*/
                            //modalBottomSheetDisclaimer(),
                            isFirstTimeLogin = true,
                            modalBottomSheetDisclaimerVerification(),
                          }
                        else
                          {
                            Helper.showToast(value.error),
                          },
                        setState(() {}),
                        loader.remove(),
                      })
                  .catchError((e) {
                Helper.showToast("Something went wrong");
                print(e);
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

  void editHashtags(EditProfile sendData, List returnData) async {
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoProfile
                  .editNeuroStatushashtag(sendData)
                  .then((value) => {
                        loader.remove(),
                        if (value.isDone)
                          {
                            Helper.showToast(value.error),
                            Navigator.pop(
                                this.scaffoldKey.currentContext!, returnData),
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

  void editNeuroStatus(
      EditProfile sendData, RouteArgument routeArgument) async {
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoProfile
                  .editNeuroStatus(sendData)
                  .then((value) => {
                        loader.remove(),
                        if (value.isDone)
                          {
                            Helper.showToast(value.error),
                            Navigator.pop(this.scaffoldKey.currentContext!,
                                routeArgument),
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

  String dis = "";

  Future<String> loadAsset() async {
    dis = await rootBundle.loadString('assets/fonts/disclaimer.txt');
    return dis;
  }

  File? _image;

  _imgFromCamera() async {
    PickedFile? image =
    // ignore: invalid_use_of_visible_for_testing_member
    await ImagePicker.platform.pickImage(
        source: ImageSource.camera, imageQuality: 70, maxWidth: 1000);

    setState(() {
      _image = new File(image!.path);
      Navigator.pushNamed(this.scaffoldKey.currentContext!, '/FaceVerification',
          arguments: new RouteArgument(file_frontphoto: new File(image.path)));
    });
  }

  _imgFromGallery() async {
    PickedFile? image =
    // ignore: invalid_use_of_visible_for_testing_member
    await ImagePicker.platform.pickImage(
        source: ImageSource.gallery, imageQuality: 70, maxWidth: 1000);

    setState(() {
      _image = new File(image!.path);
      Navigator.pushNamed(this.scaffoldKey.currentContext!, '/FaceVerification',
          arguments: new RouteArgument(file_frontphoto: new File(image.path)));
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  Container(
                    margin:
                    EdgeInsets.only(top: getProportionateScreenHeight(10)),
                    alignment: Alignment.center,
                    child: Text(
                      "Take your selfie",
                      style: TextStyle(
                          fontSize: getProportionalFontSize(16),
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w700,
                          color: Helper.hexToColor("#5BAEE2")),
                    ),
                  ),
                  new ListTile(
                      leading: new Icon(
                        Icons.photo_library,
                        color: Helper.hexToColor("#5BAEE2"),
                      ),
                      title: new Text(
                        'Photo Library',
                        style: TextStyle(
                            fontSize: getProportionalFontSize(13),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w700,
                            color: Helper.hexToColor("#393939")),
                      ),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: Helper.hexToColor("#5BAEE2"),
                    ),
                    title: new Text(
                      'Camera',
                      style: TextStyle(
                          fontSize: getProportionalFontSize(13),
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w700,
                          color: Helper.hexToColor("#393939")),
                    ),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void modalBottomSheetDisclaimerVerification() {
    final GradientPainter _painter = GradientPainter(
      strokeWidth: 1,
      radius: 35,
      gradient: new LinearGradient(
        colors: [
          Helper.hexToColor("#C078BA"),
          Helper.hexToColor("#5BAEE2"),
        ],
        stops: [0.0, 1.0],
      ),
    );
    showModalBottomSheet(
        context: this.scaffoldKey.currentContext!,
        backgroundColor: Colors.transparent,
        builder: (builder) {
          return new Container(
            width: MediaQuery.of(this.scaffoldKey.currentContext!).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/popup.png"),
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: getProportionateScreenHeightMain(24),
                            right: getProportionateScreenWidthMain(7)),
                        alignment: Alignment.center,
                        width: getProportionateScreenWidthMain(125),
                        height: getProportionateScreenWidthMain(116),
                        child: Image.asset("assets/images/security_icon.png"),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: getProportionateScreenHeightMain(47)),
                        child: Text(
                            "Verify your identity\nand\nreceive a blue tick on your profile"
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: getProportionalFontSizeMain(14),
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w700,
                                color: Helper.hexToColor("#393939"))),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: getProportionateScreenHeightMain(8),
                            left: getProportionateScreenWidthMain(30),
                            right: getProportionateScreenWidthMain(30)),
                        child: Text(
                            "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur in culpa qui officia deserunt mollit anim id est laborum.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: getProportionalFontSizeMain(14),
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w500,
                                color: Helper.hexToColor("#ffffff"))),
                      ),
                      Container(
                        height: getProportionateScreenHeightMain(36),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: getProportionateScreenWidthMain(30),
                            right: getProportionateScreenWidthMain(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(this.scaffoldKey.currentContext!);
                                modalBottomSheetDisclaimer();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: getProportionateScreenWidthMain(150),
                                height: getProportionateScreenHeightMain(60),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      getProportionateScreenWidthMain(107)),
                                ),
                                child: CustomPaint(
                                  painter: _painter,
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: getProportionateScreenWidthMain(150),
                                    height:
                                    getProportionateScreenHeightMain(60),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          getProportionateScreenWidthMain(107)),
                                    ),
                                    child: Text("Maybe later".toUpperCase(),
                                        style: TextStyle(
                                            fontSize:
                                            getProportionalFontSizeMain(14),
                                            fontFamily: 'poppins',
                                            color:
                                            Helper.hexToColor("#C078BA"))),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(this.scaffoldKey.currentContext!);
                                _showPicker(this.scaffoldKey.currentContext!);
                                //Navigator.pushNamed(context,'/FaceVerification',arguments: new RouteArgument());
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: getProportionateScreenWidthMain(150),
                                height: getProportionateScreenHeightMain(60),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      getProportionateScreenWidthMain(107)),
                                  gradient: new LinearGradient(
                                    colors: [
                                      Helper.hexToColor("#C078BA"),
                                      Helper.hexToColor("#5BAEE2"),
                                    ],
                                    stops: [0.0, 1.0],
                                  ),
                                ),
                                child: Text("yes".toUpperCase(),
                                    style: TextStyle(
                                        fontSize:
                                        getProportionalFontSizeMain(14),
                                        fontFamily: 'poppins',
                                        color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(this.scaffoldKey.currentContext!);
                      modalBottomSheetDisclaimer();
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          right: getProportionateScreenWidthMain(36),
                          bottom: getProportionateScreenHeightMain(15),
                          top: getProportionateScreenHeightMain(116)),
                      child: SvgPicture.asset("assets/images/close_icon.svg"),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void modalBottomSheetDisclaimer() {
    showModalBottomSheet(
        context: this.scaffoldKey.currentContext!,
        backgroundColor: Colors.transparent,
        builder: (builder) {
          return new Container(
            width: MediaQuery.of(this.scaffoldKey.currentContext!).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/popup.png"),
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: getProportionateScreenHeightMain(24),
                            right: getProportionateScreenWidthMain(7)),
                        alignment: Alignment.center,
                        width: getProportionateScreenWidthMain(125),
                        height: getProportionateScreenWidthMain(116),
                        child: Image.asset("assets/images/security_icon.png"),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: getProportionateScreenHeightMain(47)),
                        child: Text("disclaimer".toUpperCase(),
                            style: TextStyle(
                                fontSize: getProportionalFontSizeMain(14),
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w700,
                                color: Helper.hexToColor("#393939"))),
                      ),
                      Container(
                        height: getProportionateScreenHeightMain(110),
                        margin: EdgeInsets.only(
                            top: getProportionateScreenHeightMain(8),
                            left: getProportionateScreenWidthMain(30),
                            right: getProportionateScreenWidthMain(30)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(dis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: getProportionalFontSizeMain(14),
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w500,
                                  color: Helper.hexToColor("#393939"))),
                        ),
                      ),
                      Container(
                        height: getProportionateScreenHeightMain(36),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: getProportionateScreenWidthMain(30),
                            right: getProportionateScreenWidthMain(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /*Container(
                              alignment: Alignment.center,
                              width: getProportionateScreenWidth(150),
                              height: getProportionateScreenHeight(60),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    getProportionateScreenWidth(107)),
                                border: Border.all(
                                    color: Helper.hexToColor("#F78D23"),
                                    width: getProportionateScreenWidth(1)),
                              ),
                              child: Text("disagree".toUpperCase(),
                                  style: TextStyle(
                                      fontSize: getProportionalFontSize(14),
                                      fontFamily: 'poppins',
                                      color: Helper.hexToColor("#F78D23"))),
                            ),*/
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(this.scaffoldKey.currentContext!);
                                Navigator.pushNamed(
                                    this.scaffoldKey.currentContext!,
                                    '/Tutorial');
                              },
                              child: Container(
                                alignment: Alignment.center,
                                // margin: EdgeInsets.only(left: getProportionateScreenWidth(30),right: getProportionateScreenWidth(30)),
                                //width: MediaQuery.of(scaffoldKey.currentContext!).size.width,
                                height: getProportionateScreenHeightMain(60),
                                padding: EdgeInsets.only(
                                    left: getProportionateScreenWidthMain(68),
                                    right: getProportionateScreenWidthMain(68)),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      getProportionateScreenWidthMain(107)),
                                  gradient: new LinearGradient(
                                    colors: [
                                      Helper.hexToColor("#C078BA"),
                                      Helper.hexToColor("#5BAEE2"),
                                    ],
                                    stops: [0.0, 1.0],
                                  ),
                                ),
                                child: Text("agree and continue".toUpperCase(),
                                    style: TextStyle(
                                        fontSize:
                                            getProportionalFontSizeMain(14),
                                        fontFamily: 'poppins',
                                        color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(this.scaffoldKey.currentContext!);
                      Navigator.pushNamed(
                          this.scaffoldKey.currentContext!, '/Tutorial');
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          right: getProportionateScreenWidthMain(36),
                          bottom: getProportionateScreenHeightMain(15),
                          top: getProportionateScreenHeightMain(116)),
                      child: SvgPicture.asset("assets/images/close_icon.svg"),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void getHashTagList3(List<String> split) async {
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
                          split.forEach((element) {
                            if (elementMain.id == element) {
                              elementMain.isSelected = true;
                            }
                          });
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
}

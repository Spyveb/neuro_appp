import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Verification.dart';
import 'package:neuro/Models/route_arguments.dart';
import 'package:neuro/Repository/VerificationRepository.dart' as repoveri;
import 'package:neuro/main.dart';

class VerificationController extends ControllerMVC {
  late GlobalKey<ScaffoldState> scaffoldKey;
  late OverlayEntry loader;
  Verification sendData = new Verification();

  VerificationController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    loader = Helper.overlayLoader(this.scaffoldKey.currentContext);
    loadAsset();
  }

  File? _image;

  _imgFromCamera() async {
    PickedFile? image =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform.pickImage(
            source: ImageSource.camera, imageQuality: 70, maxWidth: 1000);

    setState(() {
      _image = new File(image!.path);

      Navigator.pop(this.scaffoldKey.currentContext!);
      Navigator.pushNamed(
          this.scaffoldKey.currentContext!, '/BackIDVerification',
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

      Navigator.pop(this.scaffoldKey.currentContext!);
      Navigator.pushNamed(
          this.scaffoldKey.currentContext!, '/BackIDVerification',
          arguments: new RouteArgument(file_frontphoto: new File(image.path)));
    });
  }

  void showPicker(context) {
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
                      "Choose your back side identity card",
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

  void passSelfieVerification() async {
    //FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    // Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoveri
                  .passVerification(sendData)
                  .then((value) => {
                        // loader.remove(),
                        //Helper.showToast("Selfie upload successfully"),
                        //showPicker(this.scaffoldKey.currentContext!),
                      })
                  .catchError((e) {
                print(e);
                Helper.showToast("Something went wrong");
              }).whenComplete(() {
                //Helper.hideLoader(loader);
              })
            }
          else
            {
              //loader.remove(),
              Helper.showToast("No Internet Connection"),
            }
        });
  }

  void passFrontIDVerification() async {
    //FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    //Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoveri
                  .passVerification(sendData)
                  .then((value) => {
                        //loader.remove(),
                        /*Helper.showToast(
                            "Front of ID card upload successfully"),*/
                        //showPicker(this.scaffoldKey.currentContext!),
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
              //  loader.remove(),
              Helper.showToast("No Internet Connection"),
            }
        });
  }

  void passBackIDVerification() async {
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoveri
                  .passVerification(sendData)
                  .then((value) => {
                        loader.remove(),
                        if (isFirstTimeLogin)
                          {
                            modalBottomSheetDisclaimer(),
                          }
                        else
                          {
                            Navigator.pop(this.scaffoldKey.currentContext!),
                          },
                        Helper.showToast(
                            "Neuropal support team will verify your profile soon."),
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
}

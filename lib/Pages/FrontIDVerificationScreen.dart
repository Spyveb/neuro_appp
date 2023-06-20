import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/VerificationController.dart';
import 'package:neuro/Helper/GradientPainter.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/route_arguments.dart';

class FrontIDVerificationScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  FrontIDVerificationScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _FrontIDVerificationState createState() => _FrontIDVerificationState();
}

class _FrontIDVerificationState extends StateMVC<FrontIDVerificationScreen> {
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

  late VerificationController _con;

  _FrontIDVerificationState() : super(VerificationController()) {
    _con = controller as VerificationController;
  }

  File? _image;

  _imgFromCamera() async {
    PickedFile? image =
    // ignore: invalid_use_of_visible_for_testing_member
    await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 70,
        maxWidth: 1000);

    setState(() {
      this.widget.routeArgument!.file_frontphoto = new File(image!.path);
    });
  }

  _imgFromGallery() async {
    PickedFile? image =
    // ignore: invalid_use_of_visible_for_testing_member
    await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, imageQuality: 70,
        maxWidth: 1000);

    setState(() {
      this.widget.routeArgument!.file_frontphoto = new File(image!.path);
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
                    EdgeInsets.only(top: getProportionateScreenHeightMain(10)),
                    alignment: Alignment.center,
                    child: Text(
                      "Choose your front side identity card",
                      style: TextStyle(
                          fontSize: getProportionalFontSizeMain(16),
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
                            fontSize: getProportionalFontSizeMain(13),
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
                          fontSize: getProportionalFontSizeMain(13),
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


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _con.scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: SvgPicture.asset(
                "assets/images/close_icon.svg",
              ),
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "front of id card".toUpperCase(),
          style: TextStyle(
              fontSize: getProportionalFontSizeMain(14),
              fontFamily: 'poppins',
              letterSpacing: 1.68,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: getProportionateScreenHeightMain(30),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: getProportionateScreenWidthMain(30),
                  right: getProportionateScreenWidthMain(30)),
              height: getProportionateScreenHeightMain(471),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                    Radius.circular(getProportionateScreenWidthMain(8))),
                child: Image.file(
                  this.widget.routeArgument!.file_frontphoto!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Container(
                margin: EdgeInsets.only(
                    left: getProportionateScreenWidthMain(30),
                    right: getProportionateScreenWidthMain(30)),
                child: Column(
                  children: [
                    Text(
                      "Is the text clear and readable?",
                      style: TextStyle(
                          fontSize: getProportionalFontSizeMain(14),
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Container(
                      height: getProportionateScreenHeightMain(44),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showPicker(context);
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
                                height: getProportionateScreenHeightMain(60),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      getProportionateScreenWidthMain(107)),
                                ),
                                child: Text("no".toUpperCase(),
                                    style: TextStyle(
                                        fontSize: getProportionalFontSizeMain(14),
                                        fontFamily: 'poppins',
                                        color: Helper.hexToColor("#C078BA"))),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _con.sendData.type = "front_image";
                            _con.sendData.file =
                                this.widget.routeArgument!.file_frontphoto!;
                            _con.passFrontIDVerification();
                            _con.showPicker(context);
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
                                    fontSize: getProportionalFontSizeMain(14),
                                    fontFamily: 'poppins',
                                    color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: getProportionateScreenHeightMain(32),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

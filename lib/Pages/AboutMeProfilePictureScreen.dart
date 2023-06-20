import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/route_arguments.dart';

class AboutMeProfilePictureScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  AboutMeProfilePictureScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _AboutMeProfileState createState() => _AboutMeProfileState();
}

class _AboutMeProfileState extends StateMVC<AboutMeProfilePictureScreen> {
  File? _image;

  _imgFromCamera() async {
    PickedFile? image =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform.pickImage(
            source: ImageSource.camera, imageQuality: 70, maxWidth: 1000);

    setState(() {
      _image = new File(image!.path);
    });
  }

  _imgFromGallery() async {
    PickedFile? image =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform.pickImage(
            source: ImageSource.gallery, imageQuality: 70, maxWidth: 1000);

    setState(() {
      _image = new File(image!.path);
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
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
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
    SizeConfig().init(context);
    return new Scaffold(
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
                "assets/images/left_arrow.svg",
              ),
            ),
          ),
        ),
        elevation: 0,
        centerTitle: false,
        title: Text(
          "ABOUT ME",
          style: TextStyle(
              letterSpacing: 1.68,
              fontSize: getProportionalFontSize(14),
              fontFamily: 'poppins',
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(top: getProportionateScreenHeight(60)),
                    alignment: Alignment.center,
                    child: Text("add your profile picture".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            letterSpacing: 1.68,
                            fontSize: getProportionalFontSize(14),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w600,
                            color: Helper.hexToColor("#393939"))),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: getProportionateScreenHeight(70)),
                      width: getProportionateScreenWidth(210),
                      height: getProportionateScreenWidth(210),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(120.0)),
                      ),
                      child: _image != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(120.0)),
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : SvgPicture.asset('assets/images/add_pic.svg'),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  if (_image == null) {
                    Helper.showToast("Please select profile picture");
                    return;
                  }
                  this.widget.routeArgument!.register!.profile = _image;
                  Navigator.pushNamed(context, '/AboutMeMorePhoto',
                      arguments: new RouteArgument(
                          register: this.widget.routeArgument!.register!));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: getProportionateScreenHeight(80),
                  child: Image.asset(
                    "assets/images/bottom_next.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

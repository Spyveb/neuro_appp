import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/ProfileController.dart';
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/UnicornOutlineButton.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Dummy.dart';
import 'package:neuro/Models/EditProfile.dart';
import 'package:neuro/Models/route_arguments.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  EditProfileScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends StateMVC<EditProfileScreen> {
  late ProfileController _con;

  _EditScreenState() : super(ProfileController(false)) {
    _con = controller as ProfileController;
  }

  File? _image;
  List<Dummy> gender_list = <Dummy>[];
  List<Dummy> mode_list = <Dummy>[];

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

  List<Asset> images = <Asset>[];
  List<String> old_images = <String>[];

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Done",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#5BAEE2",
          actionBarTitle: "Neuro",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
    this.widget.routeArgument!.profile!.more_image.removeLast();
    for (var element in images) {
      File file;
      await element
          .getThumbByteData(1000, 2000, quality: 70)
          .then((value) async => {
                file = await Helper.writeToFile(value, element.name!),
                if (!this
                    .widget
                    .routeArgument!
                    .profile!
                    .more_image
                    .contains(file))
                  {
                    this.widget.routeArgument!.profile!.more_image.add(file),
                  }
              });
    }
    this.widget.routeArgument!.profile!.more_image.add("");
    setState(() {});
  }

  var fullNameCon = TextEditingController();
  var ageCon = TextEditingController();
  var emailCon = TextEditingController();
  var aboutCon = TextEditingController();

  List<dynamic> list_personality = <dynamic>[];

  bool isPrime = false;

  getPrimeStatus() async {
    var prefs = await SharedPreferences.getInstance();
    isPrime = prefs.getBool(Constant.ISPRIME)!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    gender_list.add(Dummy("FEMALE", false));
    gender_list.add(Dummy("MALE", false));
    gender_list.add(Dummy("NON-BINARY", false));
    gender_list.add(Dummy("OTHER", false));
    mode_list.add(Dummy("DATING", false));
    mode_list.add(Dummy("FRIENDS", false));
    mode_list.add(Dummy("NETWORKING", false));
    this.widget.routeArgument!.profile!.more_image.add("");
    fullNameCon.text = this.widget.routeArgument!.profile!.name;
    ageCon.text = this.widget.routeArgument!.profile!.birthdate;
    emailCon.text = this.widget.routeArgument!.profile!.email;
    aboutCon.text = this.widget.routeArgument!.profile!.about_me;
    gender_list.forEach((element) {
      if (element.name.toUpperCase() ==
          this.widget.routeArgument!.profile!.gender.toUpperCase()) {
        element.isSelected = true;
        setState(() {});
      }
    });
    mode_list.forEach((element) {
      if (element.name.toUpperCase() ==
          this.widget.routeArgument!.profile!.mode.toUpperCase()) {
        element.isSelected = true;
        setState(() {});
      }
    });
    list_personality = this.widget.routeArgument!.profile!.personality;
    setState(() {});
    /*Future.delayed(const Duration(milliseconds: 300), () {
      print(this.widget.routeArgument!.profile!.following_applies.toString());
      _con.getHashTagList3(
          this.widget.routeArgument!.profile!.following_applies);
    });*/
    getPrimeStatus();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Scaffold(
      key: _con.scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context, "1");
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
        actions: [
          GestureDetector(
            onTap: () {
              if (fullNameCon.text.isEmpty) {
                Helper.showToast("Please enter name");
                return;
              }
              if (ageCon.text.isEmpty) {
                Helper.showToast("Please enter age");
                return;
              }
              if (emailCon.text.isEmpty) {
                Helper.showToast("Please enter email address");
                return;
              }
              if (aboutCon.text.isEmpty) {
                Helper.showToast("Please tell us about your self");
                return;
              }
              /*bool isSelected = false;
              for (int i = 0; i < gender_list.length; i++) {
                if (gender_list[i].isSelected) {
                  isSelected = true;
                  break;
                }
              }*/
              if (this.widget.routeArgument!.profile!.gender == null) {
                Helper.showToast("Please select gender");
                return;
              }
              /*List<String> selectedlist = <String>[];
              _con.list_hash.forEach((element) {
                if (element.isSelected) {
                  selectedlist.add(element.id);
                }
              });
              if (selectedlist.length == 0) {
                Helper.showToast("Please select tags");
                return;
              }*/
              /*bool isSelectedMode = false;
              for (int i = 0; i < mode_list.length; i++) {
                if (mode_list[i].isSelected) {
                  isSelectedMode = true;
                }
              }
              if (!isSelectedMode) {
                Helper.showToast("Please select mode");
                return;
              }*/
              if (list_personality.length == 0) {
                Helper.showToast("Please select personality");
              }
              EditProfile sendData = new EditProfile();
              sendData.name = fullNameCon.text.toString();
              sendData.age = ageCon.text.toString();
              sendData.email = emailCon.text.toString();
              sendData.about_me = aboutCon.text.toString();
              sendData.gender = this.widget.routeArgument!.profile!.gender;
              //sendData.following_applies = selectedlist.join(",").toString();
              /*var dataMode = mode_list.firstWhere((element) {
                return element.isSelected;
              });*/
              //sendData.mode = dataMode.name;
              //sendData.neurologicalstatus = this.widget.routeArgument!.profile!.neurologicalstatus;
              sendData.old_image = old_images.join(",");
              sendData.personality = list_personality.join(",");
              sendData.profile_imge = _image;
              this.widget.routeArgument!.profile!.more_image.forEach((element) {
                if (element is File) {
                  sendData.more_new_image.add(element);
                }
              });
              _con.editProfile(sendData);
            },
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Save",
                  style: TextStyle(
                      fontSize: getProportionalFontSize(16),
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w600,
                      color: Helper.hexToColor("#FF4350")),
                ),
              ),
            ),
          )
        ],
        elevation: 0,
        centerTitle: false,
        title: Text(
          "EDIT PROFILE",
          style: TextStyle(
              fontSize: getProportionalFontSize(14),
              letterSpacing: 1.68,
              fontFamily: 'poppins',
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
      body: this.widget.routeArgument!.profile!.name != ""
          ? SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      height: getProportionateScreenHeight(30),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          alignment: Alignment.center,
                          width: getProportionateScreenWidth(210),
                          height: getProportionateScreenWidth(210),
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(120.0)),
                              border: Border.all(
                                  color: Helper.hexToColor("#FF4350"),
                                  width: 3)),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(130.0),
                                child: Container(
                                  child: _image == null
                                      ? CachedNetworkImage(
                                      width:
                                      getProportionateScreenWidth(210),
                                      height:
                                      getProportionateScreenWidth(210),
                                      fit: BoxFit.cover,
                                      imageUrl: this
                                          .widget
                                          .routeArgument!
                                          .profile!
                                          .profile_img)
                                      : Image.file(
                                    _image!,
                                    width:
                                    getProportionateScreenWidth(210),
                                    height:
                                    getProportionateScreenWidth(210),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: getProportionateScreenWidth(0),
                                right: getProportionateScreenWidth(26),
                                child: Container(
                                  alignment: Alignment.center,
                                  /*margin: EdgeInsets.only(
                                  right: getProportionateScreenWidth(113)),*/
                                  child: SvgPicture.asset(
                                    'assets/images/ic_edit_photo.svg',
                                    height: getProportionateScreenWidth(36),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    /* Positioned(
                            bottom: getProportionateScreenWidth(4),
                            right: getProportionateScreenWidth(40),
                            child: Container(
                              width:
                              getProportionateScreenWidth(210),
                              alignment: Alignment.center,
                              *//*margin: EdgeInsets.only(
                                  right: getProportionateScreenWidth(113)),*//*
                              child: SvgPicture.asset(
                                'assets/images/ic_edit_photo.svg',
                                height: getProportionateScreenWidth(36),
                              ),
                            ),
                          ),*/
                    Container(
                      height: getProportionateScreenHeight(35),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: getProportionateScreenWidth(30),
                          right: getProportionateScreenWidth(30)),
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 0.0,
                          mainAxisSpacing: 0.0,
                        ),
                        itemCount: this
                            .widget
                            .routeArgument!
                            .profile!
                            .more_image
                            .length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: getProportionateScreenWidth(115),
                            height: getProportionateScreenWidth(115),
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                this
                                            .widget
                                            .routeArgument!
                                            .profile!
                                            .more_image[index] !=
                                        ""
                                    ? Container(
                                        width: getProportionateScreenWidth(102),
                                        height:
                                            getProportionateScreenWidth(102),
                                        padding: EdgeInsets.only(
                                            right:
                                                getProportionateScreenWidth(10),
                                            top: getProportionateScreenHeight(
                                                10)),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12))),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            child: this
                                                    .widget
                                                    .routeArgument!
                                                    .profile!
                                                    .more_image[index] is File
                                                ? Image.file(
                                                    this
                                                        .widget
                                                        .routeArgument!
                                                        .profile!
                                                        .more_image[index],
                                                    fit: BoxFit.cover,
                                                  )
                                                : CachedNetworkImage(
                                                    imageUrl: this
                                                        .widget
                                                        .routeArgument!
                                                        .profile!
                                                        .more_image[index],
                                                    fit: BoxFit.cover,
                                                  )),
                                      )
                                    : Container(
                                        width: getProportionateScreenWidth(
                                            102),
                                        height: getProportionateScreenWidth(
                                            102),
                                        padding: EdgeInsets.only(
                                            right:
                                                getProportionateScreenWidth(
                                                    10),
                                            top:
                                                getProportionateScreenHeight(
                                                    10)),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12))),
                                        child: GestureDetector(
                                          onTap: () async {
                                            loadAssets();
                                          },
                                          child: SvgPicture.asset(
                                              "assets/images/add_picplus.svg",fit: BoxFit.cover,),
                                        )),
                                this
                                            .widget
                                            .routeArgument!
                                            .profile!
                                            .more_image[index] !=
                                        ""
                                    ? Positioned(
                                        top: -3,
                                        right: -4,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (this
                                                .widget
                                                .routeArgument!
                                                .profile!
                                                .more_image[index] is File) {
                                              var file = this
                                                  .widget
                                                  .routeArgument!
                                                  .profile!
                                                  .more_image[index] as File;
                                              file.delete();
                                              this
                                                  .widget
                                                  .routeArgument!
                                                  .profile!
                                                  .more_image
                                                  .removeAt(index);
                                              setState(() {});
                                            } else {
                                              old_images.add(this
                                                  .widget
                                                  .routeArgument!
                                                  .profile!
                                                  .more_image[index]);
                                              this
                                                  .widget
                                                  .routeArgument!
                                                  .profile!
                                                  .more_image
                                                  .removeAt(index);
                                              setState(() {});
                                            }
                                          },
                                          child: Container(
                                            child: SvgPicture.asset(
                                              'assets/images/cancel_image.svg',
                                              height:
                                                  getProportionateScreenWidth(
                                                      30),
                                              fit: BoxFit.none,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: getProportionateScreenHeight(20),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: getProportionateScreenWidth(30),
                          right: getProportionateScreenWidth(30)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("Full Name",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: getProportionalFontSize(14),
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w500,
                                    color: Helper.hexToColor("#BFC5D9"))),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              controller: fullNameCon,
                              decoration: InputDecoration(
                                border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        width: 1,
                                        color: Helper.hexToColor("#E4E7F1"))),
                                focusedBorder: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        width: 1,
                                        color: Helper.hexToColor("#E4E7F1"))),
                                enabledBorder: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        width: 1,
                                        color: Helper.hexToColor("#E4E7F1"))),
                                hintText: "eg: John Doe",
                                hintStyle: TextStyle(
                                    fontSize: getProportionalFontSize(14),
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w500,
                                    color: Helper.hexToColor("#BFC5D9")),
                              ),
                              style: TextStyle(
                                  fontSize: getProportionalFontSize(16),
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w500,
                                  color: Helper.hexToColor("#393939")),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: getProportionateScreenHeight(20),
                                left: getProportionateScreenWidth(30),
                                right: getProportionateScreenWidth(30)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("Age",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: getProportionalFontSize(14),
                                          fontFamily: 'poppins',
                                          fontWeight: FontWeight.w500,
                                          color: Helper.hexToColor("#BFC5D9"))),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: TextField(
                                    controller: ageCon,
                                    readOnly: true,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            signed: true),
                                    decoration: InputDecoration(
                                      border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                              width: 1,
                                              color: Helper.hexToColor(
                                                  "#E4E7F1"))),
                                      focusedBorder: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                              width: 1,
                                              color: Helper.hexToColor(
                                                  "#E4E7F1"))),
                                      enabledBorder: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                              width: 1,
                                              color: Helper.hexToColor(
                                                  "#E4E7F1"))),
                                      hintText: "eg: 27",
                                      hintStyle: TextStyle(
                                          fontSize: getProportionalFontSize(14),
                                          fontFamily: 'poppins',
                                          fontWeight: FontWeight.w500,
                                          color: Helper.hexToColor("#BFC5D9")),
                                    ),
                                    style: TextStyle(
                                        fontSize: getProportionalFontSize(16),
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.w500,
                                        color: Helper.hexToColor("#393939")),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: getProportionateScreenHeight(20),
                          left: getProportionateScreenWidth(30),
                          right: getProportionateScreenWidth(30)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("Email",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: getProportionalFontSize(14),
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w500,
                                    color: Helper.hexToColor("#BFC5D9"))),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              readOnly: true,
                              controller: emailCon,
                              decoration: InputDecoration(
                                border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        width: 1,
                                        color: Helper.hexToColor("#E4E7F1"))),
                                focusedBorder: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        width: 1,
                                        color: Helper.hexToColor("#E4E7F1"))),
                                enabledBorder: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        width: 1,
                                        color: Helper.hexToColor("#E4E7F1"))),
                                hintText: "eg: john@gmail.com",
                                hintStyle: TextStyle(
                                    fontSize: getProportionalFontSize(14),
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w500,
                                    color: Helper.hexToColor("#BFC5D9")),
                              ),
                              style: TextStyle(
                                  fontSize: getProportionalFontSize(16),
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w500,
                                  color: Helper.hexToColor("#393939")),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: getProportionateScreenHeight(20),
                                left: getProportionateScreenWidth(30),
                                right: getProportionateScreenWidth(30)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("Bio",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: getProportionalFontSize(14),
                                          fontFamily: 'poppins',
                                          fontWeight: FontWeight.w500,
                                          color: Helper.hexToColor("#BFC5D9"))),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: TextField(
                                    controller: aboutCon,
                                    maxLines: null,
                                    maxLength: 300,
                                    decoration: InputDecoration(
                                      border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                              width: 1,
                                              color: Helper.hexToColor(
                                                  "#E4E7F1"))),
                                      focusedBorder: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                              width: 1,
                                              color: Helper.hexToColor(
                                                  "#E4E7F1"))),
                                      enabledBorder: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                              width: 1,
                                              color: Helper.hexToColor(
                                                  "#E4E7F1"))),
                                      hintText: "eg: something about your self",
                                      hintStyle: TextStyle(
                                          fontSize: getProportionalFontSize(14),
                                          fontFamily: 'poppins',
                                          fontWeight: FontWeight.w500,
                                          color: Helper.hexToColor("#BFC5D9")),
                                    ),
                                    style: TextStyle(
                                        fontSize: getProportionalFontSize(16),
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.w500,
                                        color: Helper.hexToColor("#393939")),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                        top: getProportionateScreenHeight(32),
                        left: getProportionateScreenWidth(30),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("Neurological Status",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: getProportionalFontSize(12),
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w600,
                                    color: Helper.hexToColor("#A1A1A1"))),
                          ),
                          Container(
                            height: getProportionateScreenHeight(138),
                            margin: EdgeInsets.only(
                                top: getProportionateScreenHeight(16)),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                child: Wrap(
                                  children: [
                                    Container(
                                      width: _con.widthCustom,
                                      child: Wrap(
                                        spacing:
                                            getProportionateScreenWidth(12),
                                        runSpacing:
                                            getProportionateScreenWidth(12),
                                        direction: Axis.horizontal,
                                        children: _con.list_hash.map((i) {
                                          final GradientPainter _painter =
                                              GradientPainter(
                                            strokeWidth: 1,
                                            radius: 107,
                                            gradient: new LinearGradient(
                                              colors: [
                                                Helper.hexToColor("#C078BA"),
                                                Helper.hexToColor("#5BAEE2"),
                                              ],
                                              stops: [0.0, 1.0],
                                            ),
                                          );
                                          return GestureDetector(
                                            onTap: () {
                                              if (i.isSelected) {
                                                i.isSelected = false;
                                              } else {
                                                i.isSelected = true;
                                              }
                                              setState(() {});
                                            },
                                            child: Container(
                                              width: (Helper.textSize(
                                                      i.name.toUpperCase(),
                                                      TextStyle(
                                                        fontSize:
                                                            getProportionalFontSize(
                                                                10),
                                                        fontFamily: 'poppins',
                                                      )).width +
                                                  48),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    getProportionateScreenWidth(
                                                        107)),
                                                gradient: i.isSelected
                                                    ? new LinearGradient(
                                                        colors: [
                                                          Helper.hexToColor(
                                                              "#C078BA"),
                                                          Helper.hexToColor(
                                                              "#5BAEE2"),
                                                        ],
                                                        stops: [0.0, 1.0],
                                                      )
                                                    : null,
                                              ),
                                              child: CustomPaint(
                                                painter: _painter,
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      top:
                                                          getProportionateScreenHeight(
                                                              9),
                                                      bottom:
                                                          getProportionateScreenHeight(
                                                              9)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(i.name.toUpperCase(),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  getProportionalFontSize(
                                                                      9),
                                                              fontFamily:
                                                                  'poppins',
                                                              color: i.isSelected
                                                                  ? Colors.white
                                                                  : Helper.hexToColor(
                                                                      "#C078BA"))),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),*/
                    Container(
                      height: getProportionateScreenHeight(20),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: getProportionateScreenWidth(30),
                          right: getProportionateScreenWidth(30)),
                      child: CustomOutlineButton(
                        strokeWidth: 1,
                        radius: getProportionateScreenWidth(27),
                        gradient: new LinearGradient(
                          colors: [
                            Helper.hexToColor("#C078BA"),
                            Helper.hexToColor("#5BAEE2"),
                          ],
                          stops: [0.0, 1.0],
                        ),
                        isMargin: false,
                        onPressed: () async {
                          final result = await Navigator.pushNamed(
                              context, '/EditPersonality',
                              arguments: new RouteArgument(
                                  list_personality: list_personality));
                          if (result != null) {
                            var data = result as List<dynamic>;
                            list_personality = data;
                            setState(() {});
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.83,
                          padding: EdgeInsets.only(
                              left: getProportionateScreenWidth(20),
                              right: getProportionateScreenWidth(20)),
                          height: getProportionateScreenHeight(54),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Text("Personality".toUpperCase(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: getProportionalFontSize(12),
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.w600,
                                        color: Helper.hexToColor("#FF4350"))),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Helper.hexToColor("#FF4350"),
                                    size: getProportionateScreenHeight(20),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: getProportionateScreenHeight(18),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: getProportionateScreenWidth(30),
                          right: getProportionateScreenWidth(30)),
                      child: CustomOutlineButton(
                        strokeWidth: 1,
                        radius: getProportionateScreenWidth(27),
                        gradient: new LinearGradient(
                          colors: [
                            Helper.hexToColor("#C078BA"),
                            Helper.hexToColor("#5BAEE2"),
                          ],
                          stops: [0.0, 1.0],
                        ),
                        isMargin: false,
                        onPressed: () async {
                          final result = await Navigator.pushNamed(
                              context, '/EditGender',
                              arguments: new RouteArgument(
                                  gender: this
                                      .widget
                                      .routeArgument!
                                      .profile!
                                      .gender));
                          if (result != null) {
                            this.widget.routeArgument!.profile!.gender =
                                result as String;
                            setState(() {});
                          }
                          //_modalBottomGenderDialog();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.83,
                          padding: EdgeInsets.only(
                              left: getProportionateScreenWidth(20),
                              right: getProportionateScreenWidth(20)),
                          height: getProportionateScreenHeight(54),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Text("gender".toUpperCase(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: getProportionalFontSize(12),
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.w600,
                                        color: Helper.hexToColor("#FF4350"))),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      this
                                          .widget
                                          .routeArgument!
                                          .profile!
                                          .gender,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: getProportionalFontSize(14),
                                          fontFamily: 'poppins',
                                          fontWeight: FontWeight.w500,
                                          color: Helper.hexToColor("#5BAEE2"))),
                                  Container(
                                    width: 10.12,
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Helper.hexToColor("#FF4350"),
                                    size: getProportionateScreenHeight(20),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: getProportionateScreenHeight(18),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: getProportionateScreenWidth(30),
                          right: getProportionateScreenWidth(30)),
                      child: CustomOutlineButton(
                        strokeWidth: 1,
                        radius: getProportionateScreenWidth(27),
                        gradient: new LinearGradient(
                          colors: [
                            Helper.hexToColor("#C078BA"),
                            Helper.hexToColor("#5BAEE2"),
                          ],
                          stops: [0.0, 1.0],
                        ),
                        isMargin: false,
                        onPressed: () async {
                          final result = await Navigator.pushNamed(
                              context, '/EditNeuroStatusScreen',
                              arguments: new RouteArgument(
                                  list_neurological_status: this
                                      .widget
                                      .routeArgument!
                                      .profile!
                                      .following_applies,
                                  neurologicalstatus: this
                                      .widget
                                      .routeArgument!
                                      .profile!
                                      .neurologicalstatus));
                          if (result != null) {
                            var data = result as RouteArgument;
                            if (data.following_applies != null) {
                              this
                                  .widget
                                  .routeArgument!
                                  .profile!
                                  .following_applies = data.following_applies!;
                            }
                            if (data.neurologicalstatus != null) {
                              this
                                      .widget
                                      .routeArgument!
                                      .profile!
                                      .neurologicalstatus =
                                  data.neurologicalstatus!;
                            }
                            setState(() {});
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.83,
                          padding: EdgeInsets.only(
                              left: getProportionateScreenWidth(20),
                              right: getProportionateScreenWidth(20)),
                          height: getProportionateScreenHeight(54),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Text("NEUROLOGICAL STATUS".toUpperCase(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: getProportionalFontSize(12),
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.w600,
                                        color: Helper.hexToColor("#FF4350"))),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Helper.hexToColor("#FF4350"),
                                    size: getProportionateScreenHeight(20),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: getProportionateScreenHeight(70),
                    ),
                  ],
                ),
              ),
            )
          : Container(),
    );
  }

  _modalBottomGenderDialog() {
    Future<void> future = showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(24), topLeft: Radius.circular(24)),
        ),
        barrierColor: Colors.black.withOpacity(0.7),
        builder: (builder) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Theme(
                data: ThemeData(canvasColor: Colors.transparent),
                child: new Container(
                  color: Colors.transparent,
                  padding:
                      EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 15),
                  child: Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: getProportionateScreenHeight(10)),
                        alignment: Alignment.center,
                        child: Text("HOW DO YOU IDENTIFY?".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: getProportionalFontSize(14),
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.68,
                                color: Helper.hexToColor("#393939"))),
                      ),
                      Container(
                        height: getProportionateScreenHeight(35),
                      ),
                      SizedBox(
                        //height: getProportionateScreenHeight(336),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (_, int index) {
                            return Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  left: getProportionateScreenWidth(78),
                                  right: getProportionateScreenWidth(78),
                                  bottom: getProportionateScreenHeight(24)),
                              //width: MediaQuery.of(context).size.width,
                              height: getProportionateScreenHeight(60),
                              decoration: BoxDecoration(
                                  gradient: gender_list[index].isSelected
                                      ? new LinearGradient(
                                          colors: [
                                            Helper.hexToColor("#C078BA"),
                                            Helper.hexToColor("#5BAEE2"),
                                          ],
                                          stops: [0.0, 1.0],
                                        )
                                      : null,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35))),
                              child: CustomOutlineButton(
                                strokeWidth: 1,
                                radius: getProportionateScreenWidth(35),
                                gradient: new LinearGradient(
                                  colors: [
                                    Helper.hexToColor("#C078BA"),
                                    Helper.hexToColor("#5BAEE2"),
                                  ],
                                  stops: [0.0, 1.0],
                                ),
                                isMargin: false,
                                onPressed: () {
                                  if (gender_list[index].isSelected) {
                                    gender_list[index].isSelected = false;
                                    this.widget.routeArgument!.profile!.gender =
                                        "";
                                  } else {
                                    gender_list[index].isSelected = true;
                                    this.widget.routeArgument!.profile!.gender =
                                        gender_list[index].name;
                                  }
                                  gender_list.forEach((element) {
                                    if (element.name !=
                                        gender_list[index].name) {
                                      element.isSelected = false;
                                    }
                                  });
                                  setState(() {});
                                },
                                child: Text(gender_list[index].name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: getProportionalFontSize(14),
                                        fontFamily: 'poppins',
                                        letterSpacing: 1.68,
                                        fontWeight: FontWeight.w600,
                                        color: gender_list[index].isSelected
                                            ? Helper.hexToColor("#ffffff")
                                            : Helper.hexToColor("#C078BA"))),
                              ),
                            );
                          },
                          itemCount: gender_list.length,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
    future.then((void value) => setState(() {}));
  }
}

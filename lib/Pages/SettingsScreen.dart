import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/ProfileController.dart';
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Helper/GradientPainter.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/UnicornOutlineButton.dart';
import 'package:neuro/Helper/custom_place_picker.dart' as custom;
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Dummy.dart';
import 'package:neuro/Models/Profile.dart';
import 'package:neuro/Models/route_arguments.dart';
import 'package:neuro/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  SettingsScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends StateMVC<SettingsScreen> {
  late ProfileController _con;

  _SettingsState() : super(ProfileController(false)) {
    _con = controller as ProfileController;
  }

  PickResult? selectedPlaceAddress;

  File? _image;

  _imgFromCamera() async {
    PickedFile? image =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform.pickImage(
            source: ImageSource.camera, imageQuality: 70, maxWidth: 1000);

    setState(() {
      _image = new File(image!.path);
      Navigator.pushNamed(context, '/FaceVerification',
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
      Navigator.pushNamed(context, '/FaceVerification',
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

  _modalBottomModeDialog() {
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
                        child: Text("choose a mode".toUpperCase(),
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
                                  gradient: mode_list[index].isSelected
                                      ? new LinearGradient(
                                          colors: [
                                            Helper.hexToColor("#C078BA"),
                                            Helper.hexToColor("#5BAEE2"),
                                          ],
                                          stops: [0.0, 1.0],
                                        )
                                      : null,
                                  /*border: !mode_list[index].isSelected
                                  ? Border.all(
                                      color: Helper.hexToColor("#5BAEE2"))
                                  : null,*/
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
                                  if (mode_list[index].isSelected) {
                                    mode_list[index].isSelected = false;
                                  } else {
                                    mode_list[index].isSelected = true;
                                  }
                                  mode_list.forEach((element) {
                                    if (element.name != mode_list[index].name) {
                                      element.isSelected = false;
                                    } else {
                                      Navigator.pop(context);
                                      Profile sendData = new Profile();
                                      sendData.mode = element.name;
                                      _con.editMode(sendData);
                                    }
                                  });
                                  setState(() {});
                                },
                                child: Text(mode_list[index].name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: getProportionalFontSize(14),
                                        fontFamily: 'poppins',
                                        letterSpacing: 1.68,
                                        fontWeight: FontWeight.w600,
                                        color: mode_list[index].isSelected
                                            ? Helper.hexToColor("#ffffff")
                                            : Helper.hexToColor("#C078BA"))),
                              ),
                            );
                          },
                          itemCount: mode_list.length,
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

  bool isPrime = false;

  getPrimeStatus() async {
    var prefs = await SharedPreferences.getInstance();
    isPrime = prefs.getBool(Constant.ISPRIME)!;
    setState(() {});
  }

  List<Dummy> mode_list = <Dummy>[];

  Position? _currentPosition;

  _getCurrentLocation() async {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    super.initState();
    getPrimeStatus();
    mode_list.add(Dummy("DATING", false));
    mode_list.add(Dummy("FRIENDS", false));
    mode_list.add(Dummy("NETWORKING", false));
    mode_list.forEach((element) {
      if (element.name.toUpperCase() ==
          this.widget.routeArgument!.mode!.toUpperCase()) {
        element.isSelected = true;
        setState(() {});
      }
    });
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
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
        elevation: 0,
        centerTitle: false,
        title: Text(
          "SETTINGS",
          style: TextStyle(
              fontSize: getProportionalFontSize(14),
              fontFamily: 'poppins',
              letterSpacing: 1.68,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(
            top: getProportionateScreenHeight(12),
            left: getProportionateScreenWidth(30),
            right: getProportionateScreenWidth(30)),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return custom.PlacePicker(
                        forceAndroidLocationManager: true,
                        apiKey: Constant.GOOGLEAPI,
                        initialPosition: LatLng(_currentPosition!.latitude,
                            _currentPosition!.longitude),
                        useCurrentLocation: true,
                        selectInitialPosition: true,
                        usePlaceDetailSearch: true,
                        onPlacePicked: (result) async {
                          selectedPlaceAddress = result;
                          Navigator.of(context).pop();
                          setState(() {});
                          print(result.toString());
                          var placemarks = await placemarkFromCoordinates(
                              selectedPlaceAddress!.geometry!.location.lat,
                              selectedPlaceAddress!.geometry!.location.lng);
                          print(placemarks.toString());
                          _con.sendData.address =
                              placemarks[0].locality.toString();
                          _con.sendData.latitude = selectedPlaceAddress!
                              .geometry!.location.lat
                              .toString();
                          _con.sendData.longitude = selectedPlaceAddress!
                              .geometry!.location.lng
                              .toString();
                          _con.editLocation(_con.sendData);
                        },
                        forceSearchOnZoomChanged: true,
                        automaticallyImplyAppBarLeading: true,
                        enableMapTypeButton: false,
                        desiredLocationAccuracy: LocationAccuracy.lowest,
                        resizeToAvoidBottomInset: true,
                        autocompleteLanguage: "en",
                        region: 'us',
                        selectedPlaceWidgetBuilder:
                            (_, selectedPlace, state, isSearchBarFocused) {
                          print(
                              "state: $state, isSearchBarFocused: $isSearchBarFocused");
                          return isSearchBarFocused
                              ? Container()
                              : Align(
                                  alignment: Alignment.bottomCenter,
                                  child: state == SearchingState.Searching
                                      ? Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          height:
                                              getProportionateScreenHeightMain(
                                                  150),
                                          child: Center(
                                              child: CircularProgressIndicator(
                                            color: Helper.hexToColor("#5BAEE2"),
                                          )),
                                        )
                                      : Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          margin: EdgeInsets.only(
                                              bottom:
                                                  getProportionateScreenHeightMain(
                                                      22)),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                getProportionateScreenWidth(
                                                    27.5)),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Helper.hexToColor(
                                                    "#5BAEE2"),
                                                width:
                                                    getProportionateScreenWidth(
                                                        1)),
                                          ),
                                          child: Wrap(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left:
                                                        getProportionateScreenWidthMain(
                                                            15),
                                                    right:
                                                        getProportionateScreenWidthMain(
                                                            15),
                                                    top:
                                                        getProportionateScreenHeightMain(
                                                            25),
                                                    bottom:
                                                        getProportionateScreenHeightMain(
                                                            25)),
                                                child: Text(
                                                    selectedPlace!
                                                        .formattedAddress!,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize:
                                                            getProportionalFontSizeMain(
                                                                18),
                                                        fontFamily: 'poppins',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Helper.hexToColor(
                                                                "#000000"))),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      Navigator.pop(context);
                                                      selectedPlaceAddress =
                                                          selectedPlace;
                                                      var placemarks =
                                                          await placemarkFromCoordinates(
                                                              selectedPlace
                                                                  .geometry!
                                                                  .location
                                                                  .lat,
                                                              selectedPlace
                                                                  .geometry!
                                                                  .location
                                                                  .lng);
                                                      print(placemarks
                                                          .toString());
                                                      _con.sendData.address =
                                                          placemarks[0]
                                                              .locality
                                                              .toString();
                                                      _con.sendData.latitude =
                                                          selectedPlace
                                                              .geometry!
                                                              .location
                                                              .lat
                                                              .toString();
                                                      _con.sendData.longitude =
                                                          selectedPlace
                                                              .geometry!
                                                              .location
                                                              .lng
                                                              .toString();
                                                      setState(() {});
                                                      _con.editLocation(
                                                          _con.sendData);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                getProportionateScreenWidthMain(
                                                                    12.5)),
                                                        color:
                                                            Helper.hexToColor(
                                                                "#5BAEE2"),
                                                        border: Border.all(
                                                            color: Helper
                                                                .hexToColor(
                                                                    "#5BAEE2"),
                                                            width:
                                                                getProportionateScreenWidthMain(
                                                                    1)),
                                                      ),
                                                      padding: EdgeInsets.fromLTRB(
                                                          getProportionateScreenWidthMain(
                                                              15),
                                                          getProportionateScreenHeightMain(
                                                              7),
                                                          getProportionateScreenWidthMain(
                                                              15),
                                                          getProportionateScreenHeightMain(
                                                              7)),
                                                      child: Text("Select",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  getProportionalFontSizeMain(
                                                                      18),
                                                              fontFamily:
                                                                  'poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Helper
                                                                  .hexToColor(
                                                                      "#ffffff"))),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                );
                        },
                        pinBuilder: (context, state) {
                          if (state == PinState.Idle) {
                            return Icon(Icons.add_location_outlined,
                                color: Helper.hexToColor("#5BAEE2"),
                                size: getProportionateScreenWidthMain(35));
                          } else {
                            return Icon(
                              Icons.add_location_rounded,
                              color: Helper.hexToColor("#5BAEE2"),
                              size: getProportionateScreenWidthMain(35),
                            );
                          }
                        },
                      );
                    },
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(
                    top: getProportionateScreenHeight(12),
                    bottom: getProportionateScreenHeight(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Location".toUpperCase(),
                      style: TextStyle(
                          fontSize: getProportionalFontSize(12),
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w700,
                          color: Helper.hexToColor("#393939")),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Helper.hexToColor("#53AAE0"),
                      size: getProportionateScreenHeight(20),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                if (isPrime) {
                  _modalBottomModeDialog();
                } else {
                  Helper.showToast(
                      "Please purchase premium membership for full access");
                  final result =
                      await Navigator.pushNamed(context, '/PremiumPlan');
                  if (result != null) {
                    getPrimeStatus();
                  }
                }
              },
              child: Container(
                margin: EdgeInsets.only(
                    top: getProportionateScreenHeight(12),
                    bottom: getProportionateScreenHeight(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "MODE",
                      style: TextStyle(
                          fontSize: getProportionalFontSize(12),
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w700,
                          color: Helper.hexToColor("#393939")),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Helper.hexToColor("#53AAE0"),
                      size: getProportionateScreenHeight(20),
                    )
                  ],
                ),
              ),
            ),
            !this.widget.routeArgument!.isVerified!
                ? InkWell(
                    onTap: () {
                      if (this.widget.routeArgument!.isVerified!) {
                        Helper.showToast("You are already verified user.");
                        return;
                      }
                      modalBottomSheetDisclaimer();
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: getProportionateScreenHeight(12),
                          bottom: getProportionateScreenHeight(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "verification".toUpperCase(),
                            style: TextStyle(
                                fontSize: getProportionalFontSize(12),
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w700,
                                color: Helper.hexToColor("#393939")),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: Helper.hexToColor("#53AAE0"),
                            size: getProportionateScreenHeight(20),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
            InkWell(
              onTap: () async {
                if (!isPrime) {
                  await Navigator.pushNamed(context, '/PremiumPlan');
                  getPrimeStatus();
                } else {
                  Helper.showToast("You are already a Prime member");
                }
              },
              child: Container(
                margin: EdgeInsets.only(
                    top: getProportionateScreenHeight(12),
                    bottom: getProportionateScreenHeight(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "subscriptions".toUpperCase(),
                      style: TextStyle(
                          fontSize: getProportionalFontSize(12),
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w700,
                          color: Helper.hexToColor("#393939")),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Helper.hexToColor("#53AAE0"),
                      size: getProportionateScreenHeight(20),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                final data = await Navigator.pushNamed(context, '/ManageScreen',
                    arguments: new RouteArgument(
                        isNotification:
                            this.widget.routeArgument!.isNotification));
                if(data != null){
                  this.widget.routeArgument!.isNotification = data as bool;
                  setState(() { });
                }
              },
              child: Container(
                margin: EdgeInsets.only(
                    top: getProportionateScreenHeight(12),
                    bottom: getProportionateScreenHeight(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Manage account".toUpperCase(),
                      style: TextStyle(
                          fontSize: getProportionalFontSize(12),
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w700,
                          color: Helper.hexToColor("#393939")),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Helper.hexToColor("#53AAE0"),
                      size: getProportionateScreenHeight(20),
                    )
                  ],
                ),
              ),
            ),
            Expanded(child: Container()),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  top: getProportionateScreenHeight(14),
                  bottom: getProportionateScreenHeight(38)),
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
                onPressed: () {
                  _logout();
                },
                child: Container(
                  padding: EdgeInsets.only(
                      left: getProportionateScreenWidth(20),
                      right: getProportionateScreenWidth(20)),
                  height: getProportionateScreenHeight(54),
                  width: MediaQuery.of(context).size.width * 0.83,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text("LOG OUT".toUpperCase(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: getProportionalFontSize(12),
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w600,
                                color: Helper.hexToColor("#C078BA"))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _logout() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout',
              style: TextStyle(
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w400,
                  color: Helper.hexToColor("#000000"))),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'Do you want to logout from app?',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w600,
                      color: Helper.hexToColor("#000000")),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w700,
                      color: Helper.hexToColor("#5BAEE2"))),
              onPressed: () async {
                isFirstTimeLogin = true;
                _con.logout();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('No',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w700,
                      color: Helper.hexToColor("#000000"))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void modalBottomSheetDisclaimer() {
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
        context: context,
        backgroundColor: Colors.transparent,
        builder: (builder) {
          return new Container(
            width: MediaQuery.of(context).size.width,
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
                                Navigator.pop(context);
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
                                Navigator.pop(context);
                                _showPicker(context);
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
                      Navigator.pop(context);
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

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/LoginController.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Register.dart';

class SignUpEmailScreen extends StatefulWidget {
  @override
  _SignUpEmailState createState() => _SignUpEmailState();
}

class _SignUpEmailState extends StateMVC<SignUpEmailScreen> {
  Register sendData = new Register();
  var emailCon = TextEditingController();
  var passwordCon = TextEditingController();
  Position? _currentPosition;

  late LoginController _con;

  _SignUpEmailState() : super(LoginController()) {
    _con = controller as LoginController;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  List<Placemark>? placemarks;

  _getCurrentLocation() async {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
      });

      placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      print(placemarks.toString());
      sendData.latitude = position.latitude.toString();
      sendData.longitude = position.longitude.toString();
      /*sendData.address = placemarks![0].subLocality.toString() +
          ", " +
          placemarks![0].locality.toString();*/
      sendData.address = placemarks![0].locality.toString();
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Scaffold(
      key: _con.scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              //margin: EdgeInsets.only(top: getProportionateScreenHeight(255)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: getProportionateScreenWidth(30),
                          right: getProportionateScreenWidth(30)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("Email Address",
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
                              controller: emailCon,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
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
                      height: getProportionateScreenHeight(24),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: getProportionateScreenWidth(30),
                          right: getProportionateScreenWidth(30)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("Password",
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
                              controller: passwordCon,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
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
                                hintText: "*******",
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
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: KeyboardVisibilityBuilder(
                  builder: (context, isKeyboardVisible) {
                if (isKeyboardVisible) {
                  return Container();
                }
                return GestureDetector(
                  onTap: () {
                    if (emailCon.text.isEmpty) {
                      Helper.showToast("Please enter email address");
                      return;
                    }
                    if (!Helper.isEmail(emailCon.text.toString())) {
                      Helper.showToast("Please enter valid email");
                      return;
                    }
                    if (passwordCon.text.isEmpty) {
                      Helper.showToast("Please enter password");
                      return;
                    }
                    sendData.email = emailCon.text;
                    sendData.password = passwordCon.text;
                    _con.sendLogin.gmail = emailCon.text;
                    _con.userEmailCheck(sendData);
                  },
                  child: SafeArea(
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: getProportionateScreenHeight(10),
                          left: getProportionateScreenWidth(30),
                          right: getProportionateScreenWidth(30)),
                      child: Image.asset("assets/images/singupbutton.png"),
                    ),
                  ),
                );
              }),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin:
                      EdgeInsets.only(top: getProportionateScreenHeight(35)),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: SvgPicture.asset(
                      "assets/images/left_arrow.svg",
                    ),
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

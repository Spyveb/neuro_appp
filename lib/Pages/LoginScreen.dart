import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/LoginController.dart';
import 'package:neuro/Helper/FirebaseMessages.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Register.dart';
import 'package:neuro/Models/Token.dart';
import 'package:neuro/Models/route_arguments.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends StateMVC<LoginScreen> {
  late LoginController _con;

  _LoginState() : super(LoginController()) {
    _con = controller as LoginController;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  List<Placemark>? placemarks;
  Position? _currentPosition;
  Register sendData = new Register();

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

  final Shader linearGradient = LinearGradient(
    colors: <Color>[
      Helper.hexToColor("#FFD600"),
      Helper.hexToColor("#F26336"),
    ],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 300.0, 300.0));

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Scaffold(
      key: _con.scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: Column(
          children: [
            Container(
              height: getProportionateScreenHeightMain(279),
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Container(
                    height: getProportionateScreenHeightMain(279),
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      'assets/images/rounded_bg.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: SvgPicture.asset('assets/images/logo.svg',height: getProportionateScreenHeight(130)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        margin: EdgeInsets.only(
                            bottom: getProportionateScreenHeightMain(45)),
                        child: Text(
                            "The app for like minded people".toUpperCase(),
                            style: TextStyle(
                                fontSize: getProportionalFontSizeMain(12),
                                // fontFamily: 'poppins',
                                letterSpacing: 1.68,
                                fontWeight: FontWeight.w600,
                                color: Colors.white))),
                  ),
                ],
              ),
            ),
            Container(
              height: getProportionateScreenHeightMain(28),
            ),
            GestureDetector(
              onTap: () {
                FocusScope.of(_con.scaffoldKey.currentContext!).unfocus();
                Overlay.of(_con.scaffoldKey.currentContext!)!
                    .insert(_con.loader);
                String emaildata = "";
                _con.signInWithApple().then((value) => {
                      print(value.user),
                      if (value.user!.displayName != null)
                        {
                          sendData.name = value.user!.displayName!,
                        }
                      else
                        {
                          emaildata = value.user!.email!,
                          sendData.name = emaildata.split("@")[0],
                        },
                      //sendData.name = value.user!.displayName!,
                      sendData.email = value.user!.email!,
                      sendData.type = "apple",
                      sendData.social_id = value.user!.uid,
                      sendData.deviceToken = FirebaseMessages().fcmToken,
                      _con.userSocialLogin(sendData),
                    });
              },
              child: Container(
                child: SvgPicture.asset(
                  'assets/images/apple.svg',
                  height: getProportionateScreenHeightMain(54),
                ),
              ),
            ),
            Container(
              height: getProportionateScreenHeightMain(14),
            ),
            GestureDetector(
              onTap: () {
                try {
                  FocusScope.of(_con.scaffoldKey.currentContext!).unfocus();
                  Overlay.of(_con.scaffoldKey.currentContext!)!
                      .insert(_con.loader);
                  _con.signInWithFacebook().then((value) => {
                        if (value != null)
                          {
                            print(value.user),
                            sendData.name = value.user!.displayName!,
                            if (value.user!.email != null)
                              {
                                sendData.email = value.user!.email!,
                              }
                            else
                              {
                                sendData.email = value.user!.displayName!,
                              },
                            sendData.type = "facebook",
                            sendData.social_id = value.user!.uid,
                            sendData.deviceToken = FirebaseMessages().fcmToken,
                            _con.userSocialLogin(sendData),
                          }
                        else
                          {
                            _con.loader.remove(),
                            Helper.hideLoader(_con.loader),
                          }
                      });
                } catch (e) {
                  print(e);
                }
              },
              child: Container(
                child: SvgPicture.asset(
                  'assets/images/facebook.svg',
                  height: getProportionateScreenHeightMain(54),
                ),
              ),
            ),
            Container(
              height: getProportionateScreenHeightMain(14),
            ),
            GestureDetector(
              onTap: () {
                FocusScope.of(_con.scaffoldKey.currentContext!).unfocus();
                Overlay.of(_con.scaffoldKey.currentContext!)!
                    .insert(_con.loader);
                _con.signInWithGoogle().then((value) => {
                      print(value.user),
                      sendData.name = value.user!.displayName!,
                      sendData.email = value.user!.email!,
                      sendData.type = "google",
                      sendData.social_id = value.user!.uid,
                      sendData.deviceToken = FirebaseMessages().fcmToken,
                      _con.userSocialLogin(sendData),
                    });
              },
              child: Container(
                child: SvgPicture.asset(
                  'assets/images/google.svg',
                  height: getProportionateScreenHeightMain(54),
                ),
              ),
            ),
            Container(
              height: getProportionateScreenHeightMain(14),
            ),
            GestureDetector(
              onTap: () {
                String url =
                    "https://api.instagram.com/oauth/authorize?client_id=812399549640649&redirect_uri=https://httpstat.us/200&scope=user_profile,user_media&response_type=code";
                final flutterWebviewPlugin = new FlutterWebviewPlugin();
                flutterWebviewPlugin.launch(url);
                flutterWebviewPlugin.onUrlChanged.listen((String url) async {
                  if (url.contains("code=")) {
                    String accessCode =
                        (url.split("code=")[1].replaceAll("#_", ""));
                    print(accessCode);
                    Uri myUri = Uri.parse(
                        "https://api.instagram.com/oauth/access_token");
                    final http.Response response =
                        await http.post(myUri, body: {
                      "client_id": "812399549640649",
                      "redirect_uri": "https://httpstat.us/200",
                      "client_secret": "60530e33527370566e610ea6d0bc04aa",
                      "code": accessCode,
                      "grant_type": "authorization_code"
                    });
                    await flutterWebviewPlugin.close();
                    print(response.body.toString());
                    var data = Token.fromMap(json.decode(response.body));
                    var igUserResponse = await Dio(
                            BaseOptions(baseUrl: 'https://graph.instagram.com'))
                        .get(
                      '/me',
                      queryParameters: {
                        // Get the fields you need.
                        // https://developers.facebook.com/docs/instagram-basic-display-api/reference/user
                        "fields": "username,id,account_type,media_count",
                        "access_token": data.access,
                      },
                    );

                    setState(() {
                      print(igUserResponse.data.toString());
                    });
                    FocusScope.of(_con.scaffoldKey.currentContext!).unfocus();
                    Overlay.of(_con.scaffoldKey.currentContext!)!
                        .insert(_con.loader);
                    sendData.name = igUserResponse.data['username'].toString();
                    sendData.email = "";
                    sendData.type = "instagram";
                    sendData.social_id = igUserResponse.data['id'].toString();
                    sendData.deviceToken = FirebaseMessages().fcmToken;
                    _con.userSocialLogin(sendData);
                  }
                });
              },
              child: Container(
                child: Image.asset(
                  'assets/images/insta.png',
                  height: getProportionateScreenHeightMain(54),
                ),
              ),
            ),
            Container(
              height: getProportionateScreenHeightMain(14),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/SignInEmail');
              },
              child: Container(
                child: SvgPicture.asset(
                  'assets/images/signInemail.svg',
                  height: getProportionateScreenHeightMain(54),
                ),
              ),
            ),
            Container(
              height: getProportionateScreenHeightMain(19),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: getProportionateScreenWidthMain(25),
                  right: getProportionateScreenWidthMain(25)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: SvgPicture.asset(
                      'assets/images/divider.svg',
                      width: getProportionateScreenWidthMain(136),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: getProportionateScreenWidthMain(12),
                        right: getProportionateScreenWidthMain(12)),
                    child: Text("OR",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: getProportionalFontSizeMain(14),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: Helper.hexToColor("#BFC5D9"))),
                  ),
                  Container(
                    child: SvgPicture.asset(
                      'assets/images/divider.svg',
                      width: getProportionateScreenWidthMain(136),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: getProportionateScreenHeightMain(19),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/SignUpEmail');
              },
              child: Container(
                child: SvgPicture.asset(
                  'assets/images/email.svg',
                  height: getProportionateScreenHeightMain(54),
                ),
              ),
            ),
            Container(
              height: getProportionateScreenHeightMain(19),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Terms of Use",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            // decoration: TextDecoration.underline,
                            fontSize: getProportionalFontSizeMain(14),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: Helper.hexToColor("#BFC5D9"))),
                  ),
                  Container(
                    child: Text("and  ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: getProportionalFontSizeMain(14),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: Helper.hexToColor("#BFC5D9"))),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/TermsOfUseOrPolicyScreen',
                          arguments: new RouteArgument(isTerms: false));
                    },
                    child: Container(
                      child: Text("Privacy Policy",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: getProportionalFontSizeMain(14),
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w900,
                              color: Helper.hexToColor("#FF4350"))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

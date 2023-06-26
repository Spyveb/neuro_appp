import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/LoginController.dart';
import 'package:neuro/Helper/FirebaseMessages.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';

class SignInEmailScreen extends StatefulWidget {
  @override
  _SignInEmailState createState() => _SignInEmailState();
}

class _SignInEmailState extends StateMVC<SignInEmailScreen> {
  late LoginController _con;

  _SignInEmailState() : super(LoginController()) {
    _con = controller as LoginController;
  }

  var emailCon = TextEditingController();
  var passwordCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Scaffold(
      key: _con.scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: getProportionateScreenHeight(279),
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            Container(
                              height: getProportionateScreenHeight(279),
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                'assets/images/rounded_bg.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                child:
                                    SvgPicture.asset('assets/images/logo.svg',height: getProportionateScreenHeight(130)),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  margin: EdgeInsets.only(
                                      bottom: getProportionateScreenHeight(45)),
                                  child: Text(
                                      "The app for like minded people"
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontSize: getProportionalFontSize(12),
                                          // fontFamily: 'poppins',
                                          letterSpacing: 1.68,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white))),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: getProportionateScreenHeight(55),
                      ),
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
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin:
                        EdgeInsets.only(top: getProportionateScreenHeight(5)),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: SvgPicture.asset(
                        "assets/images/left_arrow.svg",
                        color: Colors.white,
                      ),
                    ),
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
                        Helper.showToast("Please enter email");
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
                      _con.sendLogin.email = emailCon.text.toString();
                      _con.sendLogin.password = passwordCon.text.toString();
                      _con.sendLogin.deviceToken = FirebaseMessages().fcmToken;
                      _con.userLogin();
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: getProportionateScreenHeight(10),
                          left: getProportionateScreenWidth(30),
                          right: getProportionateScreenWidth(30)),
                      child: Image.asset("assets/images/signinbutton.png"),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

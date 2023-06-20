import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Register.dart';
import 'package:neuro/Models/route_arguments.dart';

class AboutMeAboutScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  AboutMeAboutScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _AboutMeAboutState createState() => _AboutMeAboutState();
}

class _AboutMeAboutState extends StateMVC<AboutMeAboutScreen> {
  var aboutCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: FooterLayout(
        child: Container(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    //top: getProportionateScreenHeight(174),
                    left: getProportionateScreenWidth(30),
                    right: getProportionateScreenWidth(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text("About",
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
                          counterStyle: TextStyle(
                            fontSize: getProportionalFontSize(11),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: Helper.hexToColor("#BFC5D9")),
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
        footer: KeyboardAttachableFooter(
            aboutCon, this.widget.routeArgument!.register),
      ),
    );
  }
}

class KeyboardAttachableFooter extends StatelessWidget {
  var aboutCon;

  Register? sendData;

  KeyboardAttachableFooter(this.aboutCon, this.sendData);

  @override
  Widget build(BuildContext context) => KeyboardAttachable(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            if (aboutCon.text.toString().isEmpty) {
              Helper.showToast("Please tell us about your self");
              return;
            }
            this.sendData!.about = this.aboutCon.text.toString();
            Navigator.pushNamed(context, '/AboutMeYourIdentify',
                arguments: new RouteArgument(register: this.sendData));
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
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/route_arguments.dart';

class AboutMeYourIdentifySpecifyScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  AboutMeYourIdentifySpecifyScreen({Key? key, this.routeArgument})
      : super(key: key);

  @override
  _AboutMeYourIdentifySpecifyState createState() =>
      _AboutMeYourIdentifySpecifyState();
}

class _AboutMeYourIdentifySpecifyState
    extends StateMVC<AboutMeYourIdentifySpecifyScreen> {
  var aboutgenderCon = TextEditingController();

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
                        EdgeInsets.only(top: getProportionateScreenHeight(50)),
                    alignment: Alignment.center,
                    child: Text("Please specify".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: getProportionalFontSize(14),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.68,
                            color: Helper.hexToColor("#393939"))),
                  ),
                  Text("(if you feel comfortable doing so)".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: getProportionalFontSize(12),
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.68,
                          color: Helper.hexToColor("#393939"))),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: getProportionateScreenHeight(48),
                      decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          border:
                              Border.all(color: Helper.hexToColor("#E4E7F1"))),
                      margin: EdgeInsets.only(
                          top: getProportionateScreenHeight(40),
                          left: getProportionateScreenWidth(30),
                          right: getProportionateScreenWidth(30)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: getProportionateScreenWidth(220),
                            //height: getProportionateScreenHeight(48),
                            child: TextField(
                              controller: aboutgenderCon,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                hintText: "",
                                hintStyle: TextStyle(
                                    fontSize: getProportionalFontSize(14),
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w400,
                                    color: Helper.hexToColor("#BFC5D9")),
                              ),
                              style: TextStyle(
                                  fontSize: getProportionalFontSize(14),
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w400,
                                  color: Helper.hexToColor("#000000")),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: getProportionateScreenHeight(6),
                                bottom: getProportionateScreenHeight(6)),
                            child: VerticalDivider(
                              thickness: 2,
                              color: Helper.hexToColor("#E4E7F1"),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (aboutgenderCon.text.isNotEmpty) {
                                this.widget.routeArgument!.register!.gender =
                                    aboutgenderCon.text;
                              }
                              // Navigator.pushNamed(context, '/AboutMeChooseMode',
                              //     arguments: new RouteArgument(
                              //         register:
                              //             this.widget.routeArgument!.register));

                              Navigator.pushNamed(context, '/AboutNeurologicalStatus',
                                  arguments: new RouteArgument(
                                      register: this.widget.routeArgument!.register!));
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: getProportionateScreenWidth(21),
                                  right: getProportionateScreenWidth(21)),
                              child: Text("ADD",
                                  style: TextStyle(
                                      fontSize: getProportionalFontSize(9),
                                      fontFamily: 'poppins',
                                      fontWeight: FontWeight.w700,
                                      color: Helper.hexToColor("#FF4350"))),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  if (aboutgenderCon.text.isNotEmpty) {
                    this.widget.routeArgument!.register!.gender =
                        aboutgenderCon.text;
                  }
                  // Navigator.pushNamed(context, '/AboutMeChooseMode',
                  //     arguments: new RouteArgument(
                  //         register: this.widget.routeArgument!.register));

                  Navigator.pushNamed(context, '/AboutNeurologicalStatus',
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

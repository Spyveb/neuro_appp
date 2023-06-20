import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:page_transition/page_transition.dart';

import 'DashboardScreen.dart';

class TutorialScreen extends StatefulWidget {
  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends StateMVC<TutorialScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: getProportionateScreenHeight(25)),
                  child: Image.asset(
                    "assets/images/neuro.png",
                    width: getProportionateScreenWidth(160),
                    //height: getProportionateScreenHeight(28),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    left: getProportionateScreenWidth(7),
                    right: getProportionateScreenWidth(7)),
                child: SvgPicture.asset(
                  'assets/images/tutorial_main.svg',
                  height: getProportionateScreenHeightMain(518.97),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: DashboardScreen()));
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: 10,
                        left: getProportionateScreenWidth(30),
                        right: getProportionateScreenWidth(30)),
                    child: Image.asset(
                      "assets/images/buttonget_start.png",
                      height: getProportionateScreenHeight(60),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

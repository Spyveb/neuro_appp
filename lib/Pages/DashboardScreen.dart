import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/KeepAlivePage.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'FeedsScreen.dart';
import 'GroupMessagesScreen.dart';
import 'MessagesScreen.dart';
import 'ProfileScreen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends StateMVC<DashboardScreen>
    with SingleTickerProviderStateMixin {
  var _bottomNavIndex = 0; //default index of a first screen

  late AnimationController _animationController;
  late Animation<double> animation;
  late CurvedAnimation curve;

  final iconList = <String>[
    "assets/images/feed.png",
    "assets/images/messages.svg",
    // "assets/images/group.svg",
    "assets/images/profile.svg",
  ];

  @override
  void initState() {
    isFirstTimeLogin = false;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    chatuserId = "";
    isInChat = false;
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(seconds: 1),
      () => _animationController.forward(),
    );
  }

  PageController pagecontroller = PageController(
    initialPage: 0,
  );

  Future<bool> pop() async {
    SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: pop,
      child: new Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).backgroundColor,
        body: AnimatedContainer(
          color: Theme.of(context).backgroundColor,
          duration: const Duration(seconds: 1),
          child: PageView(
            physics: new NeverScrollableScrollPhysics(),
            controller: pagecontroller,
            onPageChanged: _onPageChanged,
            children: [
              FeedsScreen(),
              MessagesScreen(),
              // GroupMessagesScreen(),
              KeepAlivePage(child: ProfileScreen())
            ],
          ),
        ),
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            final color = isActive
                ? Helper.hexToColor('#FF4350')
                : Helper.hexToColor("#A8A7A7");
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                index == 0
                    ? Image.asset(
                        iconList[index],
                        color: color,
                        width: getProportionateScreenWidth(24),
                        height: getProportionateScreenWidth(24),
                      )
                    : SvgPicture.asset(
                        iconList[index],
                        color: color,
                        width: getProportionateScreenWidth(24),
                        height: getProportionateScreenWidth(24),
                      ),
              ],
            );
          },
          backgroundColor: Colors.white,
          activeIndex: _bottomNavIndex,
          splashColor: Helper.hexToColor('#5BAEE2'),
          notchAndCornersAnimation: animation,
          splashSpeedInMilliseconds: 300,
          notchSmoothness: NotchSmoothness.defaultEdge,
          gapLocation: GapLocation.none,
          onTap: (index) async {
            if (index == 2) {
              var prefs = await SharedPreferences.getInstance();
              bool isPrime = prefs.getBool(Constant.ISPRIME)!;
              if (!isPrime) {
                Helper.showToast(
                    "Please purchase premium membership for full access");
                final result =
                    await Navigator.pushNamed(context, '/PremiumPlan');
                bool isPrime = prefs.getBool(Constant.ISPRIME)!;
                if (isPrime) {
                  setState(() =>
                      {_bottomNavIndex = 2, pagecontroller.jumpToPage(2)});
                }
                return;
              }
            }
            setState(() =>
                {_bottomNavIndex = index, pagecontroller.jumpToPage(index)});
          },
        ),
      ),
    );
  }

  void _onPageChanged(int page) {
    _bottomNavIndex = page;
    setState(() {});
  }
}

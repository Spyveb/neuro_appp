import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/FirebaseMessages.dart';
import 'package:neuro/Helper/PaymentService.dart';
import 'package:neuro/route_generator.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Helper/Constant.dart';
import 'Helper/FirebaseManager.dart';
import 'Helper/GlobalVariable.dart';
import 'Helper/Theme.dart';

String chatuserId = "";
bool isInChat = false;

bool isFirstTimeLogin = false;

void main() async {
  bool isLogin = false;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GlobalConfiguration().loadFromAsset("configurations");
  print(GlobalConfiguration().get("api_base_url"));
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(Constant.ISLOGIN)) {
    isLogin = (prefs.getBool(Constant.ISLOGIN))!;
  } else {
    isLogin = false;
  }
  runApp(MyApp(isLogin));
}

class MyApp extends StatefulWidget {
  bool isLogin = false;

  MyApp(this.isLogin);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends StateMVC<MyApp> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () async {
      await FirebaseMessages().getFCMToken();
      FirebaseManager().getUserList();
      if (this.widget.isLogin) {
        PaymentService().initConnection();
      }
    });
  }

  @override
  void dispose() {
    PaymentService().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (this.widget.isLogin) {
      return OverlaySupport.global(
        child: new MaterialApp(
          navigatorKey: GlobalVariable.navState,
          debugShowCheckedModeBanner: false,
          theme: ThemeMixin.getTheme(context),
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: '/Dashboard',
        ),
      );
    } else {
      return OverlaySupport.global(
        child: new MaterialApp(
          navigatorKey: GlobalVariable.navState,
          debugShowCheckedModeBanner: false,
          theme: ThemeMixin.getTheme(context),
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: '/Login',
        ),
      );
    }
  }
}

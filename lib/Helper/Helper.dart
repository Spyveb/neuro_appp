import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as textD;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/FirebaseUser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

import 'CircularLoadingWidget.dart';

class Helper {
  BuildContext? context;

  Helper.of(BuildContext context) {
    this.context = context;
  }

  static OverlayEntry overlayLoader(context) {
    OverlayEntry loader = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Positioned(
        height: size.height,
        width: size.width,
        top: 0,
        left: 0,
        child: Material(
          color: Colors.black.withOpacity(0.8),
          child:
              CircularLoadingWidget(height: getProportionateScreenHeight(200)),
        ),
      );
    });
    return loader;
  }

  static hideLoader(OverlayEntry loader) {
    Timer(Duration(milliseconds: 500), () {
      try {
        loader.remove();
      } catch (e) {}
    });
  }

  static Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  static void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        timeInSecForIosWeb: 1,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Helper.hexToColor("#5BAEE2"),
        gravity: ToastGravity.BOTTOM);
  }

  static Map<dynamic, dynamic> convertMap(dynamic map) {
    Map<dynamic, dynamic> mapDynamic;
    if (map is String) {
      var obj = json.decode(map);
      mapDynamic = obj;
      return mapDynamic;
    } else if (map is Map<dynamic, dynamic>) {
      mapDynamic = map;
      return mapDynamic;
    } else {
      return Map<String, dynamic>();
    }
  }

  static Future<bool> isConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  static Future<File> writeToFile(ByteData data, String name) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath + '/${name}';
    return new File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  // Here it is!
  static Size textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: textD.TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  static String dayFormatter(int datetime) {
    var days = int.parse(dayCalculate(datetime));

    switch (days) {
      case 0:
        DateTime d2 = DateTime.fromMillisecondsSinceEpoch(datetime);
        final DateFormat formatter = DateFormat('hh:mm a');
        final String formatted = formatter.format(d2);
        return formatted;
        break;

      default:
        DateTime d2 = DateTime.fromMillisecondsSinceEpoch(datetime);
        final DateFormat formatter = DateFormat('dd-MM-yyyy hh:mm a');
        final String formatted = formatter.format(d2);
        return formatted;
        break;
    }
  }

  static String dayCalculate(int datetime) {
    DateTime d1 = DateTime.now();
    DateTime d2 = DateTime.fromMillisecondsSinceEpoch(datetime);

    print(datetime);

    var diff = d1.difference(d2); //d2-d1
    print(diff.inDays.toString());
    return ((diff.inDays).toString());
  }

  static String getPersonalityName(String name) {
    switch (name) {
      case "Adventurous":
        return "Adventurous";
      case "Animal_lover":
        return "Animal Lover";
      case "Artsy":
        return "Artsy";
      case "Athletic":
        return "Athletic";
      case "Bookworm":
        return "Bookworm";
      case "Coffee_addict":
        return "Coffee Addict";
      case "Divorcee":
        return "Divorcee";
      case "DIY":
        return "DIY";
      case "Engaged":
        return "Engaged";
      case "Entrepreneurial":
        return "Entrepreneurial";
      case "Extravert":
        return "Extravert";
      case "Film_fan":
        return "Film Fan";
      case "Foodie":
        return "Foodie";
      case "Gamer":
        return "Gamer";
      case "Homebody":
        return "Homebody";
      case "Hopeless_romantic":
        return "Hopeless Romantic";
      case "Introvert":
        return "Introvert";
      case "Jetsetter":
        return "Jetsetter";
      case "LGBTQI":
        return "LGBTQI";
      case "Married":
        return "Married";
      case "Messy":
        return "Messy";
      case "Music_lover":
        return "Music Lover";
      case "Neat_and_tidy":
        return "Neat and Tidy";
      case "Party_animal":
        return "Party Animal";
      case "Perfectionist":
        return "Perfectionist";
      case "Performing_arts":
        return "Performing Arts";
      case "Sci_fi_enthusiast":
        return "Sci Fi Enthusiast";
      case "Shopaholic":
        return "Shopaholic";
      case "Single_parent_2":
        return "Single Parent";
      case "Student":
        return "Student";
      case "veggie":
        return "Veggie";
      case "Volunteer":
        return "Volunteer";
      case "Witchy_vibes":
        return "Witchy Vibes";
      case "Yogi":
        return "Yogi";
      default:
        return "";
    }
  }

  static List<Map> ConvertCustomStepsToMap(List<FirebaseUser> customSteps) {
    List<Map> steps = [];
    customSteps.forEach((FirebaseUser customStep) {
      Map step = customStep.toJson();
      steps.add(step);
    });
    return steps;
  }

  static getShimmerView({double? width, double? height, double? radius}) {
    if (width == null && height == null && radius != null) {
      width = radius * 2;
      height = radius * 2;
    }
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: (width ?? double.maxFinite),
        height: height ?? double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(radius ?? 0),
        ),
      ),
    );
  }
}

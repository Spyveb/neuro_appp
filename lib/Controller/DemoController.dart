import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Dummy.dart';

class DemoController extends ControllerMVC {
  List<Dummy> list_data = <Dummy>[];
  double widthCustom = 0.0;

  DemoController() {
    list_data.add(Dummy("Brain", false));
    list_data.add(Dummy("data not", false));
    list_data.add(Dummy("loreum data", false));
    list_data.add(Dummy("loreum data", false));
    list_data.add(Dummy("loreum skdj", false));
    list_data.add(Dummy("loreum sdkjfh kjh ", false));
    list_data.add(Dummy("data anya", false));
    list_data.add(Dummy("anya data", false));
    list_data.add(Dummy("wrong data", false));
    list_data.add(Dummy("not avaialble", false));
    list_data.add(Dummy("not avaialble", false));
    list_data.add(Dummy("Gril", false));
    list_data.add(Dummy("boy", false));
    list_data.add(Dummy("wrong data", false));
    list_data.add(Dummy("not avaialble", false));
    list_data.add(Dummy("Gril", false));
    list_data.add(Dummy("boy", false));
    list_data.add(Dummy("Brain", false));
    list_data.add(Dummy("Brain", false));
    list_data.add(Dummy("Brain", false));
    list_data.add(Dummy("Brain", false));
    list_data.add(Dummy("data not", false));
    list_data.add(Dummy("loreum data", false));
    list_data.add(Dummy("loreum data", false));
    list_data.add(Dummy("loreum skdj", false));
    list_data.add(Dummy("loreum sdkjfh kjh ", false));
    list_data.add(Dummy("data anya", false));
    list_data.add(Dummy("anya data", false));
    list_data.add(Dummy("wrong data", false));
    list_data.add(Dummy("not avaialble", false));
    list_data.add(Dummy("not avaialble", false));
    list_data.add(Dummy("Gril", false));
    list_data.add(Dummy("boy", false));
    list_data.add(Dummy("wrong data", false));
    list_data.add(Dummy("not avaialble", false));
    list_data.add(Dummy("Gril", false));
    list_data.add(Dummy("boy", false));
    list_data.add(Dummy("Brain", false));
    list_data.add(Dummy("Brain", false));
    list_data.add(Dummy("Brain", false));
    list_data.add(Dummy("Brain", false));
    list_data.add(Dummy("data not", false));
    list_data.add(Dummy("loreum data", false));
    list_data.add(Dummy("loreum data", false));
    list_data.add(Dummy("loreum skdj", false));
    list_data.add(Dummy("loreum sdkjfh kjh ", false));
    list_data.add(Dummy("data anya", false));
    list_data.add(Dummy("anya data", false));
    list_data.add(Dummy("wrong data", false));
    list_data.add(Dummy("not avaialble", false));
    list_data.add(Dummy("not avaialble", false));
    list_data.add(Dummy("Gril", false));
    list_data.add(Dummy("boy", false));
    list_data.add(Dummy("wrong data", false));
    list_data.add(Dummy("not avaialble", false));
    list_data.add(Dummy("Gril", false));
    list_data.add(Dummy("boy", false));
    list_data.add(Dummy("Brain", false));
    list_data.add(Dummy("Brain", false));
    list_data.add(Dummy("Brain", false));
    list_data.add(Dummy("boy", false));
    list_data.add(Dummy("wrong data", false));
    list_data.add(Dummy("not avaialble", false));
    list_data.add(Dummy("Gril", false));
    list_data.add(Dummy("boy", false));
  }

  void getList() {
    var data = StringBuffer();
    Size textSize;
    list_data.forEach((element) {
      data.write(element.name);
    });
    textSize = Helper.textSize(
        data.toString().toUpperCase(),
        TextStyle(
          fontSize: getProportionalFontSize(10),
          fontFamily: 'poppins',
        ));

    getNewWidth(list_data, (textSize.width + (list_data.length * 62)) / 8);
    setState(() {});
  }

  void getNewWidth(List<Dummy> value, double NewwidthCustom) {
    double x = 0.0;
    int row = 0;
    value.forEach((element) {
      x += 24 +
          (Helper.textSize(
              element.name.toUpperCase(),
              TextStyle(
                fontSize: getProportionalFontSize(10),
                fontFamily: 'poppins',
              ))).width +
          24 +
          14;
      if (x > NewwidthCustom) {
        x = 24 +
            (Helper.textSize(
                element.name.toUpperCase(),
                TextStyle(
                  fontSize: getProportionalFontSize(10),
                  fontFamily: 'poppins',
                ))).width +
            24 +
            14;
        row++;
      }
    });
    if (row >= 8) {
      print(row);
      getNewWidth(value, NewwidthCustom + 2);
    } else {
      print(row);
      widthCustom = NewwidthCustom;
      print(widthCustom);
      setState(() {});
    }
  }

  void getList3line() {
    var data = StringBuffer();
    Size textSize;
    list_data.forEach((element) {
      data.write(element.name.toUpperCase());
    });
    textSize = Helper.textSize(
        data.toString().toUpperCase(),
        TextStyle(
          fontSize: getProportionalFontSize(10),
          fontFamily: 'poppins',
        ));

    print((textSize.width + (list_data.length * 62)) / 3);
    getNewWidth3(list_data, (textSize.width + (list_data.length * 62)) / 3);
    setState(() {});
  }

  void getNewWidth3(List<Dummy> value, double NewwidthCustom) {
    double x = 0.0;
    int row = 0;
    value.forEach((element) {
      x += 24 +
          (Helper.textSize(
              element.name.toUpperCase(),
              TextStyle(
                fontSize: getProportionalFontSize(10),
                fontFamily: 'poppins',
              ))).width +
          24 +
          14;
      if (x > NewwidthCustom) {
        x = 24 +
            (Helper.textSize(
                element.name.toUpperCase(),
                TextStyle(
                  fontSize: getProportionalFontSize(10),
                  fontFamily: 'poppins',
                ))).width +
            24 +
            14;
        row++;
      }
    });
    if (row >= 3) {
      print(row);
      getNewWidth3(value, NewwidthCustom + 2);
    } else {
      print("else$row");
      widthCustom = NewwidthCustom;
      print(widthCustom);
      setState(() {});
    }
  }
}

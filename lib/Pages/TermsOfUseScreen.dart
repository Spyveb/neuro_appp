import 'dart:async' show Future;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/svg.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/route_arguments.dart';

class TermsOfUseScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  TermsOfUseScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _TermsOfUseState createState() => _TermsOfUseState();
}

class _TermsOfUseState extends State<TermsOfUseScreen> {
  String data = "";

  Future<String> loadAsset() async {
    if (this.widget.routeArgument!.isTerms!) {
      data = await rootBundle.loadString('assets/fonts/terms.txt');
    } else {
      data = await rootBundle.loadString('assets/fonts/policy.txt');
    }
    setState(() {});
    return data;
  }

  @override
  void initState() {
    super.initState();
    loadAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            this.widget.routeArgument!.isTerms!
                ? "TERMS OF USE"
                : "PRIVACY POLICY",
            style: TextStyle(
                letterSpacing: 1.68,
                fontSize: getProportionalFontSize(14),
                fontFamily: 'poppins',
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 18, right: 18, bottom: 35),
            child: Text(
              data,
              style: TextStyle(
                  fontSize: getProportionalFontSizeMain(14),
                  fontFamily: 'poppins',
                  height: 1.8,
                  fontWeight: FontWeight.w500,
                  color: Helper.hexToColor("#393939")),
            ),
          ),
        ));
  }
}

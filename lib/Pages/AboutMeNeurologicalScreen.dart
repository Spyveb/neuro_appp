import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/HashTagController.dart';
import 'package:neuro/Helper/GradientPainter.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/route_arguments.dart';

class AboutMeNeurologicalScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  AboutMeNeurologicalScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _AboutMeNeurologicalState createState() => _AboutMeNeurologicalState();
}

class _AboutMeNeurologicalState extends StateMVC<AboutMeNeurologicalScreen> {
  late HashTagController _con;

  _AboutMeNeurologicalState() : super(HashTagController()) {
    _con = controller as HashTagController;
  }

  final GradientPainter _painter = GradientPainter(
    strokeWidth: 1,
    radius: 35,
    gradient: new LinearGradient(
      colors: [
        Helper.hexToColor("#C078BA"),
        Helper.hexToColor("#5BAEE2"),
      ],
      stops: [0.0, 1.0],
    ),
  );

  @override
  void initState() {
    super.initState();
    /*if (this.widget.routeArgument!.register!.neurologicalstatus.toUpperCase() !=
        "Neurotypical".toUpperCase()) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _con.getHashTagList();
      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Scaffold(
      key: _con.scaffoldKey,
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: getProportionateScreenHeight(50),
                          left: getProportionateScreenWidth(30),
                          right: getProportionateScreenWidth(30)),
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
                      height: getProportionateScreenHeight(40),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: getProportionateScreenHeight(48),
                        decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            border: Border.all(
                                color: Helper.hexToColor("#E4E7F1"))),
                        margin: EdgeInsets.only(
                            //top: getProportionateScreenHeight(30),
                            bottom: getProportionateScreenHeight(24),
                            left: getProportionateScreenWidth(30),
                            right: getProportionateScreenWidth(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: getProportionateScreenWidthMain(220),
                              // height: getProportionateScreenHeight(40),
                              child: TextField(
                                controller: _con.tyepHashtagCon,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type your own",
                                  contentPadding: EdgeInsets.zero,
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
                                /*if (_con.tyepHashtagCon.text.isNotEmpty) {
                                  _con.sendData.name = _con.tyepHashtagCon.text;
                                  _con.addHashtag();
                                }*/
                                if (_con.tyepHashtagCon.text.isNotEmpty) {
                                  var findData = _con.list_hash
                                      .firstWhereOrNull((element) =>
                                          element.name.toUpperCase().trim() ==
                                          _con.tyepHashtagCon.text
                                              .toUpperCase()
                                              .trim());
                                  if (findData == null) {
                                    _con.sendData.name =
                                        _con.tyepHashtagCon.text;
                                    _con.addHashtag();
                                  } else {
                                    _con.tyepHashtagCon.clear();
                                    FocusScope.of(context).unfocus();
                                    Helper.showToast("Already added");
                                  }
                                }
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
                                        color: Helper.hexToColor("#6774A0"))),
                              ),
                            ),
                          ],
                        )),
                    Container(
                      //height: getProportionateScreenHeightMain(400),
                      height: (MediaQuery.of(context).size.height -
                          (MediaQuery.of(context).padding.top +
                              kToolbarHeight) -
                          281),
                      margin: EdgeInsets.only(
                          left: getProportionateScreenWidth(30)),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          child: Wrap(
                            children: [
                              Container(
                                width: _con.list_hash.length < 10
                                    ? (MediaQuery.of(context).size.width -
                                        getProportionateScreenWidth(30))
                                    : _con.widthCustom,
                                child: Wrap(
                                  spacing: getProportionateScreenWidth(12),
                                  runSpacing: getProportionateScreenWidth(12),
                                  direction: Axis.horizontal,
                                  children: _con.list_hash.map((i) {
                                    return GestureDetector(
                                      onTap: () {
                                        if (i.isSelected) {
                                          i.isSelected = false;
                                        } else {
                                          i.isSelected = true;
                                        }
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: (Helper.textSize(
                                                i.name.toUpperCase(),
                                                TextStyle(
                                                  fontSize:
                                                      getProportionalFontSize(
                                                          10),
                                                  letterSpacing: 1.68,
                                                  fontFamily: 'poppins',
                                                )).width +
                                            48),
                                        /*padding: EdgeInsets.only(
                                            top:
                                                getProportionateScreenHeight(9),
                                            bottom:
                                                getProportionateScreenHeight(
                                                    9)),*/
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              getProportionateScreenWidth(107)),
                                          gradient: i.isSelected
                                              ? new LinearGradient(
                                                  colors: [
                                                    Helper.hexToColor(
                                                        "#C078BA"),
                                                    Helper.hexToColor(
                                                        "#5BAEE2"),
                                                  ],
                                                  stops: [0.0, 1.0],
                                                )
                                              : null,
                                        ),
                                        child: CustomPaint(
                                          painter: _painter,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                top:
                                                    getProportionateScreenHeight(
                                                        11.5),
                                                bottom:
                                                    getProportionateScreenHeight(
                                                        11.5)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(i.name.toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize:
                                                            getProportionalFontSize(
                                                                10),
                                                        fontFamily: 'poppins',
                                                        letterSpacing: 1.68,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: i.isSelected
                                                            ? Colors.white
                                                            : Helper.hexToColor(
                                                                "#C078BA"))),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            KeyboardVisibilityBuilder(builder: (context, visible) {
              return !visible
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          List<String> selectedlist = <String>[];
                          _con.list_hash.forEach((element) {
                            if (element.isSelected) {
                              selectedlist.add(element.id);
                            }
                          });
                          if (selectedlist.length > 0) {
                            this
                                    .widget
                                    .routeArgument!
                                    .register!
                                    .following_applies =
                                selectedlist.join(",").toString();
                            Navigator.pushNamed(context, '/AboutMePersonality',
                                arguments: new RouteArgument(
                                    register:
                                        this.widget.routeArgument!.register!));
                            /*_con.sendRegister =
                                this.widget.routeArgument!.register!;

                            _con.userRegister();*/
                          } else {
                            Helper.showToast("Please select tags");
                            return;
                          }
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
                    )
                  : Container();
            }),
          ],
        ),
      ),
    );
  }
}

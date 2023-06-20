import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/HashTagController.dart';
import 'package:neuro/Helper/GradientPainter.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/EditProfile.dart';
import 'package:neuro/Models/route_arguments.dart';

class EditNeuroLogicalStatusScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  EditNeuroLogicalStatusScreen({Key? key, this.routeArgument})
      : super(key: key);

  @override
  _EditNeuroLogicalStatusState createState() => _EditNeuroLogicalStatusState();
}

class _EditNeuroLogicalStatusState
    extends StateMVC<EditNeuroLogicalStatusScreen> {
  late HashTagController _con;

  _EditNeuroLogicalStatusState() : super(HashTagController()) {
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
    Future.delayed(const Duration(milliseconds: 300), () {
      _con.getHashTagList(
          following_applies:
              this.widget.routeArgument!.list_neurological_status);
    });
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
          "Neurological status".toUpperCase(),
          style: TextStyle(
              letterSpacing: 1.68,
              fontSize: getProportionalFontSize(14),
              fontFamily: 'poppins',
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        actions: [
          InkWell(
            onTap: () {
              List<dynamic> returnData = <dynamic>[];
              List<String> selectedlistids = <String>[];
              _con.list_hash.forEach((element) {
                if (element.isSelected) {
                  returnData.add(element.name);
                  selectedlistids.add(element.id);
                }
              });
              EditProfile sendData = new EditProfile();
              sendData.following_applies = selectedlistids.join(",").toString();
              print(sendData.following_applies);
              _con.editHashtags(sendData, returnData);
            },
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(17),
                child: Icon(
                  Icons.save,
                  color: Helper.hexToColor("#5BAEE2"),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: getProportionateScreenHeight(20),
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
          ],
        ),
      ),
    );
  }
}

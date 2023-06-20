import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/UnicornOutlineButton.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Dummy.dart';
import 'package:neuro/Models/route_arguments.dart';

class AboutMeChooseModeScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  AboutMeChooseModeScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _AboutMeChooseModeState createState() => _AboutMeChooseModeState();
}

class _AboutMeChooseModeState extends StateMVC<AboutMeChooseModeScreen> {
  List<Dummy> mode_list = <Dummy>[];

  @override
  void initState() {
    mode_list.add(Dummy("DATING", false));
    mode_list.add(Dummy("FRIENDS", false));
    mode_list.add(Dummy("NETWORKING", false));
    super.initState();
  }

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
                        EdgeInsets.only(top: getProportionateScreenHeight(60)),
                    alignment: Alignment.center,
                    child: Text("choose a mode".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: getProportionalFontSize(14),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.68,
                            color: Helper.hexToColor("#393939"))),
                  ),
                  Container(
                    height: getProportionateScreenHeight(69),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(336),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (_, int index) {
                        return Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              left: getProportionateScreenWidth(78),
                              right: getProportionateScreenWidth(78),
                              bottom: getProportionateScreenHeight(24)),
                          //width: MediaQuery.of(context).size.width,
                          height: getProportionateScreenHeight(60),
                          decoration: BoxDecoration(
                              gradient: mode_list[index].isSelected
                                  ? new LinearGradient(
                                      colors: [
                                        Helper.hexToColor("#C078BA"),
                                        Helper.hexToColor("#5BAEE2"),
                                      ],
                                      stops: [0.0, 1.0],
                                    )
                                  : null,
                              /*border: !mode_list[index].isSelected
                                  ? Border.all(
                                      color: Helper.hexToColor("#5BAEE2"))
                                  : null,*/
                              borderRadius:
                                  BorderRadius.all(Radius.circular(35))),
                          child: CustomOutlineButton(
                            strokeWidth: 1,
                            radius: getProportionateScreenWidth(35),
                            gradient: new LinearGradient(
                              colors: [
                                Helper.hexToColor("#C078BA"),
                                Helper.hexToColor("#5BAEE2"),
                              ],
                              stops: [0.0, 1.0],
                            ),
                            isMargin: false,
                            onPressed: () {
                              if (mode_list[index].isSelected) {
                                mode_list[index].isSelected = false;
                              } else {
                                mode_list[index].isSelected = true;
                              }
                              mode_list.forEach((element) {
                                if (element.name != mode_list[index].name) {
                                  element.isSelected = false;
                                }
                              });
                              setState(() {});
                            },
                            child: Text(mode_list[index].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: getProportionalFontSize(14),
                                    fontFamily: 'poppins',
                                    letterSpacing: 1.68,
                                    fontWeight: FontWeight.w600,
                                    color: mode_list[index].isSelected
                                        ?  Helper.hexToColor("#ffffff")
                                        : Helper.hexToColor("#C078BA"))),
                          ),
                        );
                      },
                      itemCount: mode_list.length,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  bool isSelected = false;
                  for (int i = 0; i < mode_list.length; i++) {
                    if (mode_list[i].isSelected) {
                      isSelected = true;
                    }
                  }
                  if (!isSelected) {
                    Helper.showToast("Please select mode");
                    return;
                  }
                  var data = mode_list.firstWhere((element) {
                    return element.isSelected;
                  });
                  this.widget.routeArgument!.register!.mode = data.name;
                  //Navigator.pushNamed(context, '/AboutMePersonality',
                  Navigator.pushNamed(context, '/AboutNeurologicalStatus',
                      arguments: new RouteArgument(
                          register: this.widget.routeArgument!.register!));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: getProportionateScreenHeight(80),
                  child: Image.asset("assets/images/bottom_next.png",
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

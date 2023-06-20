import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/UnicornOutlineButton.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Dummy.dart';
import 'package:neuro/Models/route_arguments.dart';

class AboutNeurologicalStatusScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  AboutNeurologicalStatusScreen({Key? key, this.routeArgument})
      : super(key: key);

  @override
  _AboutNeurologicalStatusState createState() =>
      _AboutNeurologicalStatusState();
}

class _AboutNeurologicalStatusState
    extends StateMVC<AboutNeurologicalStatusScreen> {
  List<Dummy> mode_list = <Dummy>[];

  @override
  void initState() {
    mode_list.add(Dummy("Neurotypical", false));
    mode_list.add(Dummy("Neurodivergent", false));
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
                    child: Text(
                        "PLEASE SELECT THE FOLLOWING THAT\nAPPLIES TO YOU"
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: getProportionalFontSize(14),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.68,
                            color: Helper.hexToColor("#393939"))),
                  ),
                  Container(
                    height: getProportionateScreenHeight(40),
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
                            child: Text(mode_list[index].name.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: getProportionalFontSize(14),
                                    fontFamily: 'poppins',
                                    letterSpacing: 1.68,
                                    fontWeight: FontWeight.w600,
                                    color: mode_list[index].isSelected
                                        ? Helper.hexToColor("#ffffff")
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
                    Helper.showToast("Please select status");
                    return;
                  }
                  var data = mode_list.firstWhere((element) {
                    return element.isSelected;
                  });
                  this.widget.routeArgument!.register!.neurologicalstatus =
                      data.name;
                  if (data.name.toUpperCase() == "Neurotypical".toUpperCase()) {
                    Navigator.pushNamed(context, '/AboutMePersonality',
                        arguments: new RouteArgument(
                            register: this.widget.routeArgument!.register!));
                  } else {
                    Navigator.pushNamed(context, '/AboutMeNeurological',
                        arguments: new RouteArgument(
                            register: this.widget.routeArgument!.register!));
                  }
                  //Navigator.pushNamed(context, '/AboutMePersonality',
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

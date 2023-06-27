  import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/UnicornOutlineButton.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Dummy.dart';
import 'package:neuro/Models/route_arguments.dart';

class AboutMeYourIdentifyScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  AboutMeYourIdentifyScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _AboutMeYourIdentifyState createState() => _AboutMeYourIdentifyState();
}

class _AboutMeYourIdentifyState extends StateMVC<AboutMeYourIdentifyScreen> {
  List<Dummy> gender_list = <Dummy>[];

  @override
  void initState() {
    gender_list.add(Dummy("FEMALE", false));
    gender_list.add(Dummy("MALE", false));
    gender_list.add(Dummy("NON-BINARY", false));
    gender_list.add(Dummy("OTHER", false));
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
                    child: Text("HOW DO YOU IDENTIFY?".toUpperCase(),
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
                          height: getProportionateScreenHeight(60),
                          margin: EdgeInsets.only(
                              left: getProportionateScreenWidth(78),
                              right: getProportionateScreenWidth(78),
                              bottom: getProportionateScreenHeight(24)) ,
                          decoration: BoxDecoration(
                              gradient: gender_list[index].isSelected
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
                            isMargin:
                                false,
                            child: Text(gender_list[index].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: getProportionalFontSize(14),
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.68,
                                    color: gender_list[index].isSelected
                                        ? Helper.hexToColor("#ffffff")
                                        : Helper.hexToColor("#C078BA"))),
                            onPressed: () {
                              if (gender_list[index].isSelected) {
                                gender_list[index].isSelected = false;
                              } else {
                                gender_list[index].isSelected = true;
                              }
                              gender_list.forEach((element) {
                                if (element.name != gender_list[index].name) {
                                  element.isSelected = false;
                                }
                              });
                              setState(() {});
                            },
                          ),
                        );
                      },
                      itemCount: gender_list.length,
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
                  for (int i = 0; i < gender_list.length; i++) {
                    if (gender_list[i].isSelected) {
                      isSelected = true;
                      break;
                    }
                  }
                  if (!isSelected) {
                    Helper.showToast("Please select gender");
                    return;
                  }
                  var data = gender_list.firstWhere((element) {
                    return element.isSelected;
                  });
                  this.widget.routeArgument!.register!.gender = data.name;

                  if(data.name == "OTHER"){
                    Navigator.pushNamed(context, '/AboutMeYourIdentifySpecify',
                        arguments: new RouteArgument(
                            register: this.widget.routeArgument!.register));
                  }else{
                    Navigator.pushNamed(context, '/AboutMeChooseMode',
                        arguments: new RouteArgument(
                            register: this.widget.routeArgument!.register));
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
            ),
          ],
        ),
      ),
    );
  }
}

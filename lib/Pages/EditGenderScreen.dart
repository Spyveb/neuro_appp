import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/UnicornOutlineButton.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Dummy.dart';
import 'package:neuro/Models/route_arguments.dart';

class EditGenderScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  EditGenderScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _EditGenderState createState() => _EditGenderState();
}

class _EditGenderState extends StateMVC<EditGenderScreen> {
  List<Dummy> gender_list = <Dummy>[];

  @override
  void initState() {
    gender_list.add(Dummy("FEMALE", false));
    gender_list.add(Dummy("MALE", false));
    gender_list.add(Dummy("NON-BINARY", false));
    gender_list.add(Dummy("OTHER", false));
    super.initState();
    if (this.widget.routeArgument!.gender!.toUpperCase() == "FEMALE" ||
        this.widget.routeArgument!.gender!.toUpperCase() == "MALE" ||
        this.widget.routeArgument!.gender!.toUpperCase() == "NON-BINARY" ||
        this.widget.routeArgument!.gender!.toUpperCase() == "OTHER") {
      gender_list.forEach((element) {
        if (element.name.toUpperCase() ==
            this.widget.routeArgument!.gender!.toUpperCase()) {
          element.isSelected = true;
        }
      });
    } else {
      gender_list.forEach((element) {
        if (element.name.toUpperCase() == "OTHER") {
          element.isSelected = true;
        }
      });
    }
    setState(() {});
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
          "gender".toUpperCase(),
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
                              bottom: getProportionateScreenHeight(24)),
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
                            isMargin: false,
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
                            onPressed: () async {
                              if (gender_list[index].isSelected) {
                                if (gender_list[index].name == "OTHER") {
                                  final result = await Navigator.pushNamed(
                                      context, '/OtherGenderEdit',
                                      arguments: new RouteArgument(
                                          gender: this
                                              .widget
                                              .routeArgument!
                                              .gender));
                                  if (result != null) {
                                    Navigator.pop(context, result);
                                  }
                                } else {
                                  gender_list[index].isSelected = false;
                                }
                              } else {
                                gender_list[index].isSelected = true;
                                if (gender_list[index].name == "OTHER") {
                                  final result = await Navigator.pushNamed(
                                      context, '/OtherGenderEdit',
                                      arguments: new RouteArgument(
                                          gender: this
                                              .widget
                                              .routeArgument!
                                              .gender));
                                  if (result != null) {
                                    Navigator.pop(context, result);
                                  }
                                } else {
                                  Navigator.pop(
                                      context, gender_list[index].name);
                                }
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
          ],
        ),
      ),
    );
  }
}

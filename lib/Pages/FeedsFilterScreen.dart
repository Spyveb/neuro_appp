import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/HashTagController.dart';
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Helper/GradientPainter.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Dummy.dart';
import 'package:neuro/Models/Feed.dart';
import 'package:neuro/Models/route_arguments.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedsFilterScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  FeedsFilterScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _FeedsFilterScreen createState() => _FeedsFilterScreen();
}

class _FeedsFilterScreen extends StateMVC<FeedsFilterScreen> {
  RangeValues values = RangeValues(0, 100);
  RangeLabels labels = RangeLabels('0', "100");

  RangeValues dis_values = RangeValues(0, 100);
  RangeLabels dis_labels = RangeLabels('0', "100");

  List<Dummy> gender_list = <Dummy>[];
  List<Dummy> mode_list = <Dummy>[];

  late HashTagController _con;

  _FeedsFilterScreen() : super(HashTagController()) {
    _con = controller as HashTagController;
  }

  List<Dummy> list_images = [
    new Dummy("Adventurous", false),
    new Dummy("Animal_lover", false),
    new Dummy("Artsy", false),
    new Dummy("Athletic", false),
    new Dummy("Bookworm", false),
    new Dummy("Coffee_addict", false),
    new Dummy("Divorcee", false),
    new Dummy("DIY", false),
    new Dummy("Engaged", false),
    new Dummy("Entrepreneurial", false),
    new Dummy("Extravert", false),
    new Dummy("Film_fan", false),
    new Dummy("Foodie", false),
    new Dummy("Gamer", false),
    new Dummy("Homebody", false),
    new Dummy("Hopeless_romantic", false),
    new Dummy("Introvert", false),
    new Dummy("Jetsetter", false),
    new Dummy("LGBTQI", false),
    new Dummy("Married", false),
    new Dummy("Messy", false),
    new Dummy("Music_lover", false),
    new Dummy("Neat_and_tidy", false),
    new Dummy("Party_animal", false),
    new Dummy("Perfectionist", false),
    new Dummy("Performing_arts", false),
    new Dummy("Sci_fi_enthusiast", false),
    new Dummy("Shopaholic", false),
    new Dummy("Single_parent_2", false),
    new Dummy("Student", false),
    new Dummy("veggie", false),
    new Dummy("Volunteer", false),
    new Dummy("Witchy_vibes", false),
    new Dummy("Yogi", false),
  ];

  @override
  void initState() {
    gender_list.add(Dummy("FEMALE", false));
    gender_list.add(Dummy("MALE", false));
    gender_list.add(Dummy("NON-BINARY", false));
    gender_list.add(Dummy("OTHER", false));
    mode_list.add(Dummy("DATING", false));
    mode_list.add(Dummy("FRIENDS", false));
    mode_list.add(Dummy("NETWORKING", false));
    Feed filterOld = new Feed();
    if (this.widget.routeArgument!.filterData != null) {
      filterOld = this.widget.routeArgument!.filterData!;
      if (filterOld.minage.isNotEmpty) {
        values = new RangeValues(
            double.parse(filterOld.minage), double.parse(filterOld.maxage));
        dis_values = new RangeValues(double.parse(filterOld.mindistance),
            double.parse(filterOld.maxdistance));
        gender_list.forEach((element) {
          if (element.name.toUpperCase() == filterOld.gender) {
            element.isSelected = true;
            setState(() {});
          }
        });
        mode_list.forEach((element) {
          if (element.name.toUpperCase() == filterOld.mode) {
            element.isSelected = true;
            setState(() {});
          }
        });
        list_images.forEach((element) {
          filterOld.persnalitylist.forEach((elementnew) {
            if (elementnew == element.name) {
              element.isSelected = true;
              setState(() {});
            }
          });
        });
      }
    }
    super.initState();
    getPrimeStatus();
    Future.delayed(const Duration(milliseconds: 300), () {
      _con.getHashTagList3(filterOld.hashtag.split(","));
    });
  }

  bool isPrime = false;

  getPrimeStatus() async {
    var prefs = await SharedPreferences.getInstance();
    isPrime = prefs.getBool(Constant.ISPRIME)!;
    setState(() {});
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
        centerTitle: true,
        title: Text(
          "FILTER",
          style: TextStyle(
              fontSize: getProportionalFontSize(14),
              fontFamily: 'poppins',
              letterSpacing: 1.68,
              fontWeight: FontWeight.w700,
              color: Helper.hexToColor("#393939")),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: getProportionateScreenHeight(36),
                    left: getProportionateScreenWidth(30),
                    right: getProportionateScreenWidth(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("Distance",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: getProportionalFontSize(12),
                              fontFamily: 'poppins',
                              letterSpacing: 0.96,
                              fontWeight: FontWeight.w600,
                              color: Helper.hexToColor("#A1A1A1"))),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: getProportionateScreenHeight(10),
                      ),
                      child: RangeSlider(
                          activeColor: Helper.hexToColor("#5BAEE2"),
                          inactiveColor: Helper.hexToColor("#E4E7F1"),
                          min: 0,
                          max: 100,
                          values: dis_values,
                          labels: dis_labels,
                          divisions: 100,
                          onChanged: (value) {
                            print("START: ${value.start}, End: ${value.end}");
                            setState(() {
                              dis_values = value;
                              dis_labels = RangeLabels(
                                  "${value.start.toInt().toString()} mi",
                                  "${value.end.toInt().toString()} mi");
                            });
                          }),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: getProportionateScreenHeight(32),
                    left: getProportionateScreenWidth(30),
                    right: getProportionateScreenWidth(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("Age",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: getProportionalFontSize(12),
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.96,
                              color: Helper.hexToColor("#A1A1A1"))),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: getProportionateScreenHeight(10),
                      ),
                      child: RangeSlider(
                          activeColor: Helper.hexToColor("#5BAEE2"),
                          inactiveColor: Helper.hexToColor("#E4E7F1"),
                          min: 0,
                          max: 100,
                          values: values,
                          labels: labels,
                          divisions: 100,
                          onChanged: (value) {
                            print("START: ${value.start}, End: ${value.end}");
                            setState(() {
                              values = value;
                              labels = RangeLabels(
                                  "${value.start.toInt().toString()} age",
                                  "${value.end.toInt().toString()} age");
                            });
                          }),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: getProportionateScreenHeight(32),
                    left: getProportionateScreenWidth(30),
                    right: getProportionateScreenWidth(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("Gender",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: getProportionalFontSize(12),
                              fontFamily: 'poppins',
                              letterSpacing: 0.96,
                              fontWeight: FontWeight.w600,
                              color: Helper.hexToColor("#A1A1A1"))),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: getProportionateScreenHeight(14)),
                      //width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: getProportionateScreenWidth(12),
                        runSpacing: getProportionateScreenWidth(12),
                        children: gender_list.map((i) {
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
                          return GestureDetector(
                              onTap: () {
                                if (i.isSelected) {
                                  i.isSelected = false;
                                } else {
                                  i.isSelected = true;
                                }
                                gender_list.forEach((element) {
                                  if (element.name != i.name) {
                                    element.isSelected = false;
                                  }
                                });
                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: i.isSelected
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
                                child: CustomPaint(
                                  painter: _painter,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: getProportionateScreenWidth(24),
                                        right: getProportionateScreenWidth(24),
                                        top: getProportionateScreenHeight(11.5),
                                        bottom:
                                            getProportionateScreenHeight(11.5)),
                                    child: Text(i.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize:
                                                getProportionalFontSize(10),
                                            fontFamily: 'poppins',
                                            letterSpacing: 1.68,
                                            fontWeight: FontWeight.w600,
                                            color: i.isSelected
                                                ? Colors.white
                                                : Helper.hexToColor(
                                                    "#C078BA"))),
                                  ),
                                ),
                              ));
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: getProportionateScreenHeight(32),
                  left: getProportionateScreenWidth(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("Neurological Status",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: getProportionalFontSize(12),
                              fontFamily: 'poppins',
                              letterSpacing: 0.96,
                              fontWeight: FontWeight.w600,
                              color: Helper.hexToColor("#A1A1A1"))),
                    ),
                    Container(
                      //height: getProportionateScreenHeight(150),
                      margin: EdgeInsets.only(
                          top: getProportionateScreenHeight(16)),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          child: Wrap(
                            children: [
                              Container(
                                width: _con.widthCustom,
                                child: Wrap(
                                  spacing: getProportionateScreenWidth(12),
                                  runSpacing: getProportionateScreenWidth(12),
                                  direction: Axis.horizontal,
                                  children: _con.list_hash.map((i) {
                                    final GradientPainter _painter =
                                        GradientPainter(
                                      strokeWidth: 1,
                                      radius: 107,
                                      gradient: new LinearGradient(
                                        colors: [
                                          Helper.hexToColor("#C078BA"),
                                          Helper.hexToColor("#5BAEE2"),
                                        ],
                                        stops: [0.0, 1.0],
                                      ),
                                    );
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
                                                                9),
                                                        letterSpacing: 1.68,
                                                        fontFamily: 'poppins',
                                                        fontWeight: FontWeight.w600,
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
              Container(
                margin: EdgeInsets.only(
                    top: getProportionateScreenHeight(32),
                    left: getProportionateScreenWidth(30),
                    right: getProportionateScreenWidth(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("Mode",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: getProportionalFontSize(12),
                              letterSpacing: 0.96,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w600,
                              color: Helper.hexToColor("#A1A1A1"))),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: getProportionateScreenHeight(14)),
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: getProportionateScreenWidth(12),
                        runSpacing: getProportionateScreenWidth(12),
                        children: mode_list.map((i) {
                          final GradientPainter _painter = GradientPainter(
                            strokeWidth: 1,
                            radius: 107,
                            gradient: new LinearGradient(
                              colors: [
                                Helper.hexToColor("#C078BA"),
                                Helper.hexToColor("#5BAEE2"),
                              ],
                              stops: [0.0, 1.0],
                            ),
                          );
                          return GestureDetector(
                              onTap: () async {
                                if (isPrime) {
                                  if (i.isSelected) {
                                    i.isSelected = false;
                                  } else {
                                    i.isSelected = true;
                                  }
                                  mode_list.forEach((element) {
                                    if (element.name != i.name) {
                                      element.isSelected = false;
                                    }
                                  });
                                  setState(() {});
                                } else {
                                  Helper.showToast(
                                      "Please purchase premium membership for full access");
                                  final result = await Navigator.pushNamed(
                                      context, '/PremiumPlan');
                                  if (result != null) {
                                    getPrimeStatus();
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: i.isSelected
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
                                child: CustomPaint(
                                  painter: _painter,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: getProportionateScreenWidth(24),
                                        right: getProportionateScreenWidth(24),
                                        top: getProportionateScreenHeight(11.5),
                                        bottom:
                                            getProportionateScreenHeight(11.5)),
                                    child: Text(i.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize:
                                                getProportionalFontSize(10),
                                            fontFamily: 'poppins',
                                            letterSpacing: 1.68,
                                            fontWeight: FontWeight.w600,
                                            color: i.isSelected
                                                ? Colors.white
                                                : Helper.hexToColor(
                                                    "#C078BA"))),
                                  ),
                                ),
                              ));
                        }).toList(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: getProportionateScreenHeight(32)),
                      child: Text("Personality",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              letterSpacing: 0.96,
                              fontSize: getProportionalFontSize(12),
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w600,
                              color: Helper.hexToColor("#A1A1A1"))),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: getProportionateScreenHeight(10),
                    left: getProportionateScreenWidth(10),
                    right: getProportionateScreenWidth(10),
                    bottom: getProportionateScreenHeight(0)),
                child: GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: getProportionateScreenWidth(10),
                    mainAxisSpacing: getProportionateScreenWidth(10),
                  ),
                  itemCount: list_images.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (list_images[index].isSelected) {
                          list_images[index].isSelected = false;
                        } else {
                          list_images[index].isSelected = true;
                        }
                        setState(() {});
                      },
                      splashColor: Helper.hexToColor("#5BAEE2"),
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            !list_images[index].isSelected
                                ? ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(0.5),
                                        BlendMode.dstOut),
                                    child: SvgPicture.asset(
                                      "assets/images/personality/${list_images[index].name}.svg",
                                      height: getProportionateScreenWidth(65),
                                    ),
                                  )
                                : SvgPicture.asset(
                                    "assets/images/personality/${list_images[index].name}.svg",
                                    height: getProportionateScreenWidth(65),
                                  ),
                            Container(
                              width: getProportionateScreenWidth(70),
                              margin: EdgeInsets.only(
                                  top: getProportionateScreenHeight(10)),
                              child: Text(
                                  Helper.getPersonalityName(
                                      list_images[index].name),
                                  textAlign: TextAlign.center,
                                  //maxLines: 1,
                                  //overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      height: 1.2,
                                      fontSize: getProportionalFontSize(12),
                                      fontFamily: 'poppins',
                                      fontWeight: FontWeight.w700,
                                      color: list_images[index].isSelected
                                          ? Colors.black
                                          : Helper.hexToColor("#A1A1A1"))),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: getProportionateScreenHeight(30),
                    left: getProportionateScreenWidth(30),
                    right: getProportionateScreenWidth(30),bottom: getProportionateScreenHeight(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Feed data = new Feed();
                        data.minage = "";
                        data.maxage = "";
                        data.mindistance = "";
                        data.maxdistance = "";
                        data.gender = "";
                        data.hashtag = "";
                        data.mode = "";
                        data.persnalitylist = [];
                        Navigator.pop(context, data);
                      },
                      child: Container(
                          child: Image.asset(
                        "assets/images/reset.png",
                        width: getProportionateScreenWidth(111),
                        height: getProportionateScreenHeight(60),
                      )),
                    ),
                    GestureDetector(
                      onTap: () {
                        Feed data = new Feed();
                        data.minage = values.start.toInt().toString();
                        data.maxage = values.end.toInt().toString();
                        data.mindistance = dis_values.start.toInt().toString();
                        data.maxdistance = dis_values.end.toInt().toString();
                        gender_list.forEach((element) {
                          if (element.isSelected) {
                            data.gender = element.name.toUpperCase();
                          }
                        });
                        mode_list.forEach((element) {
                          if (element.isSelected) {
                            data.mode = element.name.toUpperCase();
                          }
                        });
                        List<String> selectedlist = <String>[];
                        _con.list_hash.forEach((element) {
                          if (element.isSelected) {
                            selectedlist.add(element.id);
                          }
                        });
                        List<String> returnDataPer = <String>[];
                        list_images.forEach((element) {
                          if (element.isSelected) {
                            returnDataPer.add(element.name);
                          }
                        });
                        data.persnalitylist = returnDataPer;
                        data.hashtag = selectedlist.join(",").toString();
                        Navigator.pop(context, data);
                      },
                      child: Container(
                          child: Image.asset(
                        "assets/images/apply_filter.png",
                        width: getProportionateScreenWidth(188),
                        height: getProportionateScreenHeight(60),
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

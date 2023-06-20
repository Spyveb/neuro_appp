import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/HashTagController.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Dummy.dart';
import 'package:neuro/Models/route_arguments.dart';

class AboutMePersonalityScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  AboutMePersonalityScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _AboutMePersonalityState createState() => _AboutMePersonalityState();
}

class _AboutMePersonalityState extends StateMVC<AboutMePersonalityScreen> {
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

  late HashTagController _con;

  _AboutMePersonalityState() : super(HashTagController()) {
    _con = controller as HashTagController;
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
          "ABOUT PERSONALITY",
          style: TextStyle(
              letterSpacing: 1.68,
              fontSize: getProportionalFontSize(14),
              fontFamily: 'poppins',
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
                top: getProportionateScreenHeight(10),
                left: getProportionateScreenWidth(10),
                right: getProportionateScreenWidth(10),
                bottom: getProportionateScreenHeight(80)),
            child: GridView.builder(
              shrinkWrap: true,
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
                                  fontSize: getProportionalFontSize(9),
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
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                List<String> selectedlist = <String>[];
                list_images.forEach((element) {
                  if (element.isSelected) {
                    selectedlist.add(element.name);
                  }
                });
                if (selectedlist.length > 0) {
                  this.widget.routeArgument!.register!.personality =
                      selectedlist.join(",");
                  /*Navigator.pushNamed(context, '/AboutMeNeurological',
                      arguments: new RouteArgument(
                          register: this.widget.routeArgument!.register!));*/
                  _con.sendRegister =
                                this.widget.routeArgument!.register!;

                            _con.userRegister();
                } else {
                  Helper.showToast("Please select personality");
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
        ],
      ),
    );
  }
}

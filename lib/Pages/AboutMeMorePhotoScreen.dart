import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/route_arguments.dart';

class AboutMeMorePhotoScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  AboutMeMorePhotoScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _AboutMeMorePhotoState createState() => _AboutMeMorePhotoState();
}

class _AboutMeMorePhotoState extends StateMVC<AboutMeMorePhotoScreen> {
  List<File> imageList = <File>[];
  List<Asset> images = <Asset>[];

  @override
  void initState() {
    imageList.add(new File(""));
    super.initState();
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Done",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#5BAEE2",
          actionBarTitle: "Recu",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
    imageList.clear();
    for (var element in images) {
      File file;
      await element
          .getThumbByteData(1000, 2000, quality: 70)
          .then((value) async => {
                file = await Helper.writeToFile(value, element.name!),
                if (!imageList.contains(file))
                  {
                    imageList.add(file),
                  }
              });
    }
    imageList.add(new File(""));
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
                    child: Text("add more photos".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: getProportionalFontSize(14),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.68,
                            color: Helper.hexToColor("#393939"))),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: getProportionateScreenWidth(30),
                        right: getProportionateScreenWidth(30),
                        top: getProportionateScreenHeight(35)),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: imageList.length,
                      itemBuilder: (context, index) {
                        return imageList[index].path == ""
                            ? GestureDetector(
                                onTap: () async {
                                  loadAssets();
                                },
                                child: Container(
                                    width: getProportionateScreenWidth(95),
                                    height: getProportionateScreenWidth(95),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Container(
                                        child: SvgPicture.asset(
                                            "assets/images/add_picplus.svg"))),
                              )
                            : Container(
                                width: getProportionateScreenWidth(95),
                                height: getProportionateScreenWidth(95),
                                decoration: BoxDecoration(
                                    gradient: new LinearGradient(
                                      colors: [
                                        Helper.hexToColor("#F26336"),
                                        Helper.hexToColor("#FFD600"),
                                      ],
                                      stops: [0.0, 1.0],
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    child: Image.file(
                                      imageList[index],
                                      fit: BoxFit.cover,
                                    )),
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  imageList.removeLast();
                  this.widget.routeArgument!.register!.moreimages.clear();
                  this
                      .widget
                      .routeArgument!
                      .register!
                      .moreimages
                      .addAll(imageList);
                  Navigator.pushNamed(context, '/AboutMeAge',
                      arguments: new RouteArgument(
                          register: this.widget.routeArgument!.register));
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

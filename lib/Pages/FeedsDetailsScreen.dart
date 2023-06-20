import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:interactiveviewer_gallery/hero_dialog_route.dart';
import 'package:interactiveviewer_gallery/interactiveviewer_gallery.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/FeedController.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/MessageUser.dart';
import 'package:neuro/Models/Profile.dart';
import 'package:neuro/Models/Report.dart';
import 'package:neuro/Models/route_arguments.dart';

class FeedsDetailsScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  FeedsDetailsScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _FeedDetailsState createState() => _FeedDetailsState();
}

class _FeedDetailsState extends StateMVC<FeedsDetailsScreen> {
  List<String> image_list = <String>[];
  List<String> neurological_list = <String>[];

  late FeedController _con;

  _FeedDetailsState() : super(FeedController(false)) {
    _con = controller as FeedController;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      _con.sendDataProfile.id = this.widget.routeArgument!.FeedId!;
      _con.getuserProfile();
    });
  }

  _showReportDailog(BuildContext context) {
    var descriptionCon = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Material(
            color: Colors.white,
            type: MaterialType.transparency,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(getProportionateScreenWidth(15)),
                  height: getProportionateScreenHeight(300),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10),
                      ),
                      shape: BoxShape.rectangle),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  top: getProportionateScreenHeight(20),
                                  left: getProportionateScreenWidth(25),
                                  right: getProportionateScreenWidth(25)),
                              child: Text(
                                "Report",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: getProportionalFontSize(22),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: getProportionateScreenHeight(15),
                                    right: getProportionateScreenHeight(15)),
                                alignment: Alignment.topRight,
                                child: ClipRRect(
                                  child: SvgPicture.asset(
                                    "assets/images/close_icon.svg",
                                    width: getProportionateScreenWidth(15),
                                    height: getProportionateScreenWidth(15),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10),
                              ),
                              shape: BoxShape.rectangle),
                          height: getProportionateScreenHeight(150),
                          child: new TextField(
                            autofocus: true,
                            controller: descriptionCon,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            style: TextStyle(
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 15, top: 15, right: 15),
                              hintStyle: new TextStyle(
                                  fontFamily: 'poppins',
                                  color: Colors.grey,
                                  fontSize: getProportionalFontSize(16)),
                              hintText: "Write the reason for Reporting.",
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 3,
                                    blurRadius: 10,
                                    color: Helper.hexToColor("#5BAEE2")),
                              ],
                              shape: BoxShape.rectangle),
                          child: SizedBox(
                            height: getProportionateScreenHeight(40),
                            width: getProportionateScreenWidth(120),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (descriptionCon.text.isEmpty) {
                                  Helper.showToast("Please write reason");
                                  return;
                                }
                                Report sendData = new Report();
                                sendData.user_id = _con.data.id;
                                sendData.description = descriptionCon.text;
                                _con.reportUser(sendData);
                                Navigator.pop(context);
                              },
                              child: Text(
                                "SUBMIT",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'poppins',
                                    fontSize: 25.00,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Scaffold(
      key: _con.scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      body: _con.data.id.isNotEmpty
          ? SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SingleChildScrollView(
                      child: Container(
                        //height: MediaQuery.of(context).size.height,
                        margin: EdgeInsets.only(
                            bottom: getProportionateScreenHeight(124)),
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              width: MediaQuery.of(context).size.width,
                              height: getProportionateScreenHeight(366),
                              imageUrl: _con.data.profile_img,
                              imageBuilder: (context, imageProvider) => InkWell(
                                onTap: () {
                                  var indexData = _con.data.sourceList
                                      .firstWhere((element) =>
                                          element.url == _con.data.profile_img);
                                  var indexView =
                                      _con.data.sourceList.indexOf(indexData);
                                  Navigator.of(context).push(
                                    HeroDialogRoute<void>(
                                      builder: (BuildContext context) =>
                                          InteractiveviewerGallery<
                                              DemoSourceEntity>(
                                        sources: _con.data.sourceList,
                                        initIndex: indexView,
                                        itemBuilder: (BuildContext context,
                                            int index, bool isFocus) {
                                          return GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () =>
                                                Navigator.of(context).pop(),
                                            child: Center(
                                              child: Hero(
                                                tag: _con
                                                    .data.sourceList[index].id,
                                                child: CachedNetworkImage(
                                                  imageUrl: _con.data
                                                      .sourceList[index].url,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        onPageChanged: (int pageIndex) {
                                          print("nell-pageIndex:$pageIndex");
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: getProportionateScreenHeight(18),
                                      left: getProportionateScreenWidth(30),
                                      right: getProportionateScreenWidth(30)),
                                  alignment: Alignment.topCenter,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 8,
                                                top: 4,
                                                bottom: 4,
                                                right: 2),
                                            child: Icon(
                                              Icons.arrow_back_ios,
                                              color: Colors.white,
                                              size: getProportionateScreenWidth(
                                                  18),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _showReportDailog(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Icon(
                                              Icons.more_vert,
                                              color: Colors.white,
                                              size: getProportionateScreenWidth(
                                                  18),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              placeholder: (context, url) {
                                return Helper.getShimmerView(
                                    width: MediaQuery.of(context).size.width,
                                    height: getProportionateScreenHeight(366));
                              },
                            ),
                            Container(
                              height: getProportionateScreenHeight(24),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: getProportionateScreenWidth(30),
                                  right: getProportionateScreenWidth(20)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: _con.data.isVerified
                                        ? _con.widthCustomName + 25
                                        : _con.widthCustomName,
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: _con.widthCustomName,
                                          alignment: Alignment.centerLeft,
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                                "${_con.data.name}, ${_con.data.birthdate}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontSize:
                                                        getProportionalFontSize(
                                                            30),
                                                    fontFamily: 'poppins',
                                                    fontWeight: FontWeight.w700,
                                                    color: Helper.hexToColor(
                                                        "#3D3B3B"))),
                                          ),
                                        ),
                                        if (_con.data.isVerified)
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: Image.asset(
                                              "assets/images/verified.png",
                                              width: 16,
                                              height: 16,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    //margin: EdgeInsets.only(top: 14),
                                    padding: EdgeInsets.only(
                                        left: getProportionateScreenWidth(12),
                                        right: getProportionateScreenWidth(12)),
                                    alignment: Alignment.center,
                                    height: getProportionateScreenHeight(25),
                                    decoration: BoxDecoration(
                                        gradient: new LinearGradient(
                                          colors: [
                                            Helper.hexToColor("#C078BA"),
                                            Helper.hexToColor("#5BAEE2"),
                                          ],
                                          stops: [0.0, 1.0],
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(35))),
                                    child: Text(
                                        "${_con.data.gender}".toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize:
                                                getProportionalFontSize(8),
                                            letterSpacing:
                                                getProportionateScreenWidth(
                                                    1.68),
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                left: getProportionateScreenWidth(30),
                              ),
                              alignment: Alignment.topLeft,
                              child: Text("${_con.data.address}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: getProportionalFontSize(12),
                                      fontFamily: 'poppins',
                                      fontWeight: FontWeight.w700,
                                      color: Helper.hexToColor("#A1A1A1"))),
                            ),
                            Container(
                              height: getProportionateScreenHeight(16),
                            ),
                            _con.data.more_image.length > 0
                                ? Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(
                                        left: getProportionateScreenWidth(21)),
                                    height: getProportionateScreenWidth(95),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemBuilder: (_, int index) {
                                        return InkWell(
                                          onTap: () {
                                            var indexData = _con.data.sourceList
                                                .firstWhere((element) =>
                                                    element.url ==
                                                    _con.data
                                                        .more_image[index]);
                                            var indexView = _con.data.sourceList
                                                .indexOf(indexData);
                                            Navigator.of(context).push(
                                              HeroDialogRoute<void>(
                                                builder: (BuildContext
                                                        context) =>
                                                    InteractiveviewerGallery<
                                                        DemoSourceEntity>(
                                                  sources: _con.data.sourceList,
                                                  initIndex: indexView,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index,
                                                          bool isFocus) {
                                                    return GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .opaque,
                                                      onTap: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      child: Center(
                                                        child: Hero(
                                                          tag: _con
                                                              .data
                                                              .sourceList[index]
                                                              .id,
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: _con
                                                                .data
                                                                .sourceList[
                                                                    index]
                                                                .url,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  onPageChanged:
                                                      (int pageIndex) {
                                                    print(
                                                        "nell-pageIndex:$pageIndex");
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                right:
                                                    getProportionateScreenWidth(
                                                        15)),
                                            width:
                                                getProportionateScreenWidth(95),
                                            height:
                                                getProportionateScreenWidth(95),
                                            alignment: Alignment.center,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  _con.data.more_image[index],
                                              width:
                                                  getProportionateScreenWidth(
                                                      95),
                                              height:
                                                  getProportionateScreenWidth(
                                                      95),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          getProportionateScreenWidth(
                                                              12)),
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              placeholder: (context, url) {
                                                return Helper.getShimmerView(
                                                    width:
                                                        getProportionateScreenWidth(
                                                            95),
                                                    height:
                                                        getProportionateScreenWidth(
                                                            95),
                                                    radius: 12);
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: _con.data.more_image.length,
                                    ),
                                  )
                                : Container(),
                            _con.data.more_image.length > 0
                                ? Container(
                                    height: getProportionateScreenHeight(20),
                                  )
                                : Container(),
                            Container(
                              height: getProportionateScreenHeight(20),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: getProportionateScreenWidth(30),
                                  right: getProportionateScreenWidth(30)),
                              child: Divider(
                                color: Helper.hexToColor("#E4E7F1"),
                                thickness: 1,
                              ),
                            ),
                            Container(
                              height: getProportionateScreenHeight(14),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: getProportionateScreenWidth(30),
                                  right: getProportionateScreenWidth(30)),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text("about".toUpperCase(),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize:
                                                getProportionalFontSize(10),
                                            fontFamily: 'poppins',
                                            letterSpacing: 1.68,
                                            fontWeight: FontWeight.w700,
                                            color:
                                                Helper.hexToColor("#3D3B3B"))),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: getProportionateScreenHeight(4)),
                                    alignment: Alignment.topLeft,
                                    child: Text("${_con.data.about_me}",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize:
                                                getProportionalFontSize(14),
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Helper.hexToColor("#A1A1A1"))),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: getProportionateScreenHeight(14),
                                  left: getProportionateScreenWidth(30),
                                  right: getProportionateScreenWidth(30)),
                              child: Divider(
                                color: Helper.hexToColor("#E4E7F1"),
                                thickness: 1,
                              ),
                            ),
                            Container(
                              height: getProportionateScreenHeight(20),
                            ),
                            _con.data.neurologicalstatus.toUpperCase() !=
                                        "Neurotypical".toUpperCase() &&
                                    _con.data.following_applies.length > 0
                                ? Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left:
                                                getProportionateScreenWidth(30),
                                            right: getProportionateScreenWidth(
                                                30)),
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                  "neurological status"
                                                      .toUpperCase(),
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize:
                                                          getProportionalFontSize(
                                                              10),
                                                      fontFamily: 'poppins',
                                                      letterSpacing: 1.68,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Helper.hexToColor(
                                                          "#3D3B3B"))),
                                            ),
                                            Container(
                                              height:
                                                  getProportionateScreenHeight(
                                                      16),
                                            ),
                                            Container(
                                              /*margin: EdgeInsets.only(
                                            left: getProportionateScreenWidth(30),
                                            right: getProportionateScreenWidth(30)),*/
                                              alignment: Alignment.centerLeft,
                                              child: Wrap(
                                                alignment: WrapAlignment.start,
                                                spacing:
                                                    getProportionateScreenWidth(
                                                        12),
                                                runSpacing:
                                                    getProportionateScreenWidth(
                                                        12),
                                                children: _con
                                                    .data.following_applies
                                                    .map((i) {
                                                  return Container(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            getProportionateScreenWidth(
                                                                24),
                                                        right:
                                                            getProportionateScreenWidth(
                                                                24),
                                                        top:
                                                            getProportionateScreenHeight(
                                                                11.5),
                                                        bottom:
                                                            getProportionateScreenHeight(
                                                                11.5)),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Helper.hexToColor(
                                                                "#EAF7FF"),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    107))),
                                                    child: Text(i.toUpperCase(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize:
                                                                getProportionalFontSize(
                                                                    10),
                                                            letterSpacing: 1.68,
                                                            fontFamily:
                                                                'poppins',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Helper
                                                                .hexToColor(
                                                                    "#42A1DC"))),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            _con.data.neurologicalstatus.toUpperCase() !=
                                        "Neurotypical".toUpperCase() &&
                                    _con.data.following_applies.length > 0
                                ? Container(
                                    margin: EdgeInsets.only(
                                        top: getProportionateScreenHeight(20),
                                        left: getProportionateScreenWidth(30),
                                        right: getProportionateScreenWidth(30)),
                                    child: Divider(
                                      color: Helper.hexToColor("#E4E7F1"),
                                      thickness: 1,
                                    ),
                                  )
                                : Container(),
                            _con.data.neurologicalstatus.toUpperCase() !=
                                        "Neurotypical".toUpperCase() &&
                                    _con.data.following_applies.length > 0
                                ? Container(
                                    height: getProportionateScreenHeight(20),
                                  )
                                : Container(),
                            Container(
                              margin: EdgeInsets.only(
                                  left: getProportionateScreenWidth(30),
                                  right: getProportionateScreenWidth(30)),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom:
                                            getProportionateScreenHeight(14)),
                                    alignment: Alignment.topLeft,
                                    child: Text("Personality".toUpperCase(),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize:
                                                getProportionalFontSize(10),
                                            letterSpacing: 1.68,
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w700,
                                            color:
                                                Helper.hexToColor("#3D3B3B"))),
                                  ),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing:
                                          getProportionateScreenWidth(8),
                                      mainAxisSpacing:
                                          getProportionateScreenWidth(10),
                                    ),
                                    itemCount: _con.data.personality.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {},
                                        splashColor:
                                            Helper.hexToColor("#5BAEE2"),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/images/personality/${_con.data.personality[index]}.svg",
                                                height:
                                                    getProportionateScreenWidth(
                                                        55),
                                              ),
                                              Container(
                                                width:
                                                    getProportionateScreenWidth(
                                                        70),
                                                margin: EdgeInsets.only(
                                                    top:
                                                        getProportionateScreenHeight(
                                                            10)),
                                                child: Text(
                                                    Helper.getPersonalityName(
                                                        _con.data.personality[
                                                            index]),
                                                    textAlign: TextAlign.center,
                                                    //maxLines: 1,
                                                    //overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        height: 1.2,
                                                        fontSize:
                                                            getProportionalFontSize(
                                                                9),
                                                        fontFamily: 'poppins',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  /*ResponsiveGridList(
                                      rowMainAxisAlignment:
                                          MainAxisAlignment.start,
                                      scroll: false,
                                      desiredItemWidth:
                                          getProportionateScreenWidth(55),
                                      minSpacing:
                                          getProportionateScreenWidth(12),
                                      children: _con.data.personality.map((i) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                            bottom:
                                                getProportionateScreenHeight(
                                              25,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Column(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/images/personality/${i}.svg",
                                                height:
                                                    getProportionateScreenWidth(
                                                        55),
                                              ),
                                              Container(
                                                width:
                                                    getProportionateScreenWidth(
                                                        70),
                                                margin: EdgeInsets.only(
                                                    top:
                                                        getProportionateScreenHeight(
                                                            10)),
                                                child: Text(
                                                    Helper.getPersonalityName(
                                                        i),
                                                    textAlign: TextAlign.center,
                                                    //maxLines: 1,
                                                    //overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        height: 1.2,
                                                        fontSize:
                                                            getProportionalFontSize(
                                                                12),
                                                        fontFamily: 'poppins',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black)),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList()),*/
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  !this.widget.routeArgument!.isNormal!
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: getProportionateScreenHeight(124),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                    "assets/images/bottom_action_bar.png"),
                              ),
                            ),
                            child: this.widget.routeArgument!.isMatches!
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          MessageUser userChat =
                                              new MessageUser(
                                                  _con.data.id,
                                                  _con.data.profile_img,
                                                  _con.data.name);
                                          final result =
                                              await Navigator.pushNamed(
                                                  context, '/FirebaseChat',
                                                  arguments: new RouteArgument(
                                                      userChat: userChat,
                                                      isMatches: true));
                                        },
                                        child: Container(
                                          child: Image.asset(
                                            'assets/images/shadow_message_icon.png',
                                            width:
                                                getProportionateScreenWidth(90),
                                            height:
                                                getProportionateScreenWidth(90),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _con.sendSwipe.swipe = "0";
                                          _con.sendSwipe.receiver_id =
                                              _con.data.id;
                                          _con.feedSwipe(true);
                                        },
                                        child: Container(
                                          child: Image.asset(
                                            'assets/images/noicon.png',
                                            width:
                                                getProportionateScreenWidth(70),
                                            height:
                                                getProportionateScreenWidth(70),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: getProportionateScreenWidth(12),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _con.sendSwipe.swipe = "1";
                                          _con.sendSwipe.receiver_id =
                                              _con.data.id;
                                          _con.feedSwipe(true);
                                        },
                                        child: Container(
                                          child: Image.asset(
                                            'assets/images/yesicon.png',
                                            width:
                                                getProportionateScreenWidth(70),
                                            height:
                                                getProportionateScreenWidth(70),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                          ),
                        )
                      : Container(),
                ],
              ),
            )
          : Container(),
    );
  }
}

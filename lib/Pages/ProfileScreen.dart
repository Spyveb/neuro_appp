import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:interactiveviewer_gallery/hero_dialog_route.dart';
import 'package:interactiveviewer_gallery/interactiveviewer_gallery.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/ProfileController.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/UnicornOutlineButton.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Profile.dart';
import 'package:neuro/Models/route_arguments.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends StateMVC<ProfileScreen> {
  late ProfileController _con;

  _ProfileState() : super(ProfileController(true)) {
    _con = controller as ProfileController;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Scaffold(
      key: _con.scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        actions: [
          GestureDetector(
              onTap: () async {
                final result = await Navigator.pushNamed(
                    context, '/EditProfile',
                    arguments: new RouteArgument(profile: _con.data));
                if (result != null) {
                  _con.data = new Profile();
                  setState(() {});
                  _con.getProfile();
                }
              },
              child: Container(
                child: Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: SvgPicture.asset(
                    "assets/images/edit.svg",
                    height: getProportionateScreenHeight(18),
                  ),
                ),
              ))
        ],
        elevation: 0,
        leadingWidth: getProportionateScreenWidth(20),
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text(
          "PROFILE",
          style: TextStyle(
              fontSize: getProportionalFontSize(14),
              fontFamily: 'poppins',
              letterSpacing: 1.68,
              fontWeight: FontWeight.w700,
              color: Helper.hexToColor("#000000")),
        ),
      ),
      body: SingleChildScrollView(
        child: _con.data.notification != ""
            ? Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        var indexData = _con.data.sourceList.firstWhere(
                            (element) => element.url == _con.data.profile_img);
                        var indexView = _con.data.sourceList.indexOf(indexData);
                        Navigator.of(context).push(
                          HeroDialogRoute<void>(
                            builder: (BuildContext context) =>
                                InteractiveviewerGallery<DemoSourceEntity>(
                              sources: _con.data.sourceList,
                              initIndex: indexView,
                              itemBuilder: (BuildContext context, int index,
                                  bool isFocus) {
                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Center(
                                    child: Hero(
                                      tag: _con.data.sourceList[index].id,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            _con.data.sourceList[index].url,
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
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.width,
                        height: getProportionateScreenHeight(366),
                        imageUrl: _con.data.profile_img,
                        imageBuilder: (context, imageProvider) => Container(
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
                        ),
                        placeholder: (context, url) {
                          return Helper.getShimmerView(
                              width: MediaQuery.of(context).size.width,
                              height: getProportionateScreenHeight(366));
                        },
                      ),
                    ),
                    Container(
                      height: getProportionateScreenHeight(24),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: getProportionateScreenWidth(30),
                          right: getProportionateScreenWidth(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                getProportionalFontSize(30),
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w700,
                                            color:
                                                Helper.hexToColor("#3D3B3B"))),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(35))),
                            child: Text("${_con.data.gender}".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: getProportionalFontSize(8),
                                    letterSpacing:
                                        getProportionateScreenWidth(1.68),
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
                                            _con.data.more_image[index]);
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
                                                  tag: _con.data
                                                      .sourceList[index].id,
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
                                    margin: EdgeInsets.only(
                                        right: getProportionateScreenWidth(15)),
                                    width: getProportionateScreenWidth(95),
                                    height: getProportionateScreenWidth(95),
                                    alignment: Alignment.center,
                                    child: CachedNetworkImage(
                                      imageUrl: _con.data.more_image[index],
                                      width: getProportionateScreenWidth(95),
                                      height: getProportionateScreenWidth(95),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.circular(
                                              getProportionateScreenWidth(12)),
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      placeholder: (context, url) {
                                        return Helper.getShimmerView(
                                            width:
                                                getProportionateScreenWidth(95),
                                            height:
                                                getProportionateScreenWidth(95),
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
                                    fontSize: getProportionalFontSize(10),
                                    letterSpacing: 1.68,
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w700,
                                    color: Helper.hexToColor("#3D3B3B"))),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: getProportionateScreenHeight(4)),
                            alignment: Alignment.topLeft,
                            child: Text("${_con.data.about_me}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: getProportionalFontSize(14),
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w500,
                                    color: Helper.hexToColor("#A1A1A1"))),
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
                            "Neurotypical".toUpperCase() && _con.data.following_applies.length > 0
                        ? Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: getProportionateScreenWidth(30),
                                    right: getProportionateScreenWidth(30)),
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                          "neurological status".toUpperCase(),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              letterSpacing: 1.68,
                                              fontSize:
                                                  getProportionalFontSize(10),
                                              fontFamily: 'poppins',
                                              fontWeight: FontWeight.w700,
                                              color: Helper.hexToColor(
                                                  "#3D3B3B"))),
                                    ),
                                    Container(
                                      height: getProportionateScreenHeight(16),
                                    ),
                                    Container(
                                      /*margin: EdgeInsets.only(
                                    left: getProportionateScreenWidth(30),
                                    right: getProportionateScreenWidth(30)),*/
                                      alignment: Alignment.centerLeft,
                                      child: Wrap(
                                        alignment: WrapAlignment.start,
                                        spacing:
                                            getProportionateScreenWidth(12),
                                        runSpacing:
                                            getProportionateScreenWidth(12),
                                        children: _con.data.following_applies
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
                                                color: Helper.hexToColor(
                                                    "#EAF7FF"),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(107))),
                                            child: Text(i.toUpperCase(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize:
                                                        getProportionalFontSize(
                                                            10),
                                                    fontFamily: 'poppins',
                                                    letterSpacing: 1.68,
                                                    fontWeight: FontWeight.w600,
                                                    color: Helper.hexToColor(
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
                            "Neurotypical".toUpperCase() && _con.data.following_applies.length > 0
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
                            "Neurotypical".toUpperCase()&& _con.data.following_applies.length > 0
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
                            alignment: Alignment.topLeft,
                            child: Text("Personality".toUpperCase(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: getProportionalFontSize(10),
                                    fontFamily: 'poppins',
                                    letterSpacing: 1.68,
                                    fontWeight: FontWeight.w700,
                                    color: Helper.hexToColor("#3D3B3B"))),
                          ),
                          Container(
                            height: getProportionateScreenHeight(24),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: getProportionateScreenWidth(8),
                              mainAxisSpacing: getProportionateScreenWidth(10),
                            ),
                            itemCount: _con.data.personality.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {

                                },
                                splashColor: Helper.hexToColor("#5BAEE2"),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/personality/${_con.data.personality[index]}.svg",
                                        height: getProportionateScreenWidth(55),
                                      ),
                                      Container(
                                        width: getProportionateScreenWidth(70),
                                        margin: EdgeInsets.only(
                                            top: getProportionateScreenHeight(10)),
                                        child: Text(
                                            Helper.getPersonalityName(
                                                _con.data.personality[index]),
                                            textAlign: TextAlign.center,
                                            //maxLines: 1,
                                            //overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                height: 1.2,
                                                fontSize: getProportionalFontSize(9),
                                                fontFamily: 'poppins',
                                                fontWeight: FontWeight.w700,
                                                color:
                                                     Colors.black
                                                    )),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          /*ResponsiveGridList(
                              rowMainAxisAlignment: MainAxisAlignment.start,
                              scroll: false,
                              desiredItemWidth: getProportionateScreenWidth(55),
                              minSpacing: getProportionateScreenWidth(12),
                              children: _con.data.personality.map((i) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      bottom: getProportionateScreenHeight(25)),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/personality/${i}.svg",
                                        height: getProportionateScreenWidth(55),
                                      ),
                                      Container(
                                        width: getProportionateScreenWidth(70),
                                        margin: EdgeInsets.only(
                                            top: getProportionateScreenHeight(
                                                10)),
                                        child: Text(
                                            Helper.getPersonalityName(i),
                                            textAlign: TextAlign.center,
                                            //maxLines: 1,
                                            //overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                height: 1.2,
                                                fontSize:
                                                    getProportionalFontSize(12),
                                                fontFamily: 'poppins',
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black)),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList()),*/
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: getProportionateScreenHeight(0),
                          left: getProportionateScreenWidth(30),
                          right: getProportionateScreenWidth(30),
                          bottom: getProportionateScreenHeight(20)),
                      child: Divider(
                        color: Helper.hexToColor("#E4E7F1"),
                        thickness: 1,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: getProportionateScreenWidth(30),
                          bottom: getProportionateScreenHeight(20),
                          right: getProportionateScreenWidth(30)),
                      child: CustomOutlineButton(
                        strokeWidth: 1,
                        radius: getProportionateScreenWidth(27),
                        gradient: new LinearGradient(
                          colors: [
                            Helper.hexToColor("#C078BA"),
                            Helper.hexToColor("#5BAEE2"),
                          ],
                          stops: [0.0, 1.0],
                        ),
                        isMargin: false,
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/Settings',
                              arguments: new RouteArgument(
                                  mode: _con.data.mode,
                                  isVerified: _con.data.isVerified,
                                  isNotification: _con.isNotification));
                          _con.data = new Profile();
                          setState(() {});
                          _con.getProfile();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.83,
                          padding: EdgeInsets.only(
                              left: getProportionateScreenWidth(20),
                              right: getProportionateScreenWidth(20)),
                          height: getProportionateScreenHeight(54),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Text("settings".toUpperCase(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: getProportionalFontSize(12),
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.w600,
                                        color: Helper.hexToColor("#C078BA"))),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/setting_icon.svg",
                                    height: getProportionateScreenHeight(23),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Helper.hexToColor("#53AAE0"),
                                    size: getProportionateScreenHeight(20),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    /*Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: getProportionateScreenHeight(14),
                          left: getProportionateScreenWidth(30),
                          right: getProportionateScreenWidth(30),
                          bottom: getProportionateScreenHeight(20)),
                      child: CustomOutlineButton(
                        strokeWidth: 1,
                        radius: getProportionateScreenWidth(27),
                        gradient: new LinearGradient(
                          colors: [
                            Helper.hexToColor("#C078BA"),
                            Helper.hexToColor("#5BAEE2"),
                          ],
                          stops: [0.0, 1.0],
                        ),
                        isMargin: false,
                        onPressed: () {},
                        child: Container(
                          padding: EdgeInsets.only(
                              left: getProportionateScreenWidth(20),
                              right: getProportionateScreenWidth(20)),
                          height: getProportionateScreenHeight(54),
                          width: MediaQuery.of(context).size.width * 0.83,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Text("Notifications".toUpperCase(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: getProportionalFontSize(12),
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.w600,
                                        color: Helper.hexToColor("#C078BA"))),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FlutterSwitch(
                                    width: getProportionateScreenWidth(51),
                                    height: getProportionateScreenHeight(31),
                                    value: _con.isNotification,
                                    onToggle: (val) async {
                                      setState(() {
                                        _con.isNotification = val;
                                        _con.sendNotificationData.notification =
                                            val ? "1" : "0";
                                        _con.updateNotifcationStatus();
                                      });
                                    },
                                    activeColor: Helper.hexToColor("#53AAE0"),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),*/
                  ],
                ),
              )
            : Container(),
      ),
    );
  }

  _logout() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout',
              style: TextStyle(
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w400,
                  color: Helper.hexToColor("#000000"))),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'Do you want to logout from app?',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w600,
                      color: Helper.hexToColor("#000000")),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w700,
                      color: Helper.hexToColor("#5BAEE2"))),
              onPressed: () async {
                _con.logout();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('No',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w700,
                      color: Helper.hexToColor("#000000"))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _deleteAccount() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account',
              style: TextStyle(
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w400,
                  color: Helper.hexToColor("#000000"))),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'Do you want to delete account from app?',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w600,
                      color: Helper.hexToColor("#000000")),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w700,
                      color: Helper.hexToColor("#5BAEE2"))),
              onPressed: () async {
                _con.deleteaccount();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('No',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w700,
                      color: Helper.hexToColor("#000000"))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

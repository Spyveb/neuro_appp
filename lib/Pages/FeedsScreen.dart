import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swipecards/flutter_swipecards.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/FeedController.dart';
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Helper/FirebaseMessages.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Feed.dart';
import 'package:neuro/Models/route_arguments.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedsScreen extends StatefulWidget {
  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends StateMVC<FeedsScreen> {
  CardController _cardController = new CardController();

  late FeedController _con;

  _FeedsState() : super(FeedController(true)) {
    _con = controller as FeedController;
  }

  String mode = "";

  final Shader linearGradient = LinearGradient(
    colors: <Color>[
      Helper.hexToColor("#C078BA"),
      Helper.hexToColor("#5BAEE2"),
    ],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 300.0, 300.0));

  @override
  void initState() {
    super.initState();
    getModeData();
    FirebaseMessaging.instance.getInitialMessage().then((value) => {
          if (value != null)
            {
              FirebaseMessages.notificationOperation(payload: value.data),
            }
        });
  }

  getModeData() async {
    var prefs = await SharedPreferences.getInstance();
    mode = prefs.getString(Constant.MODE)!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _con.scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: getProportionateScreenHeightMain(50),
                          bottom: getProportionateScreenHeightMain(10)),
                      child: Image.asset(
                        "assets/images/neuro.png",
                        width: getProportionateScreenWidthMain(160),
                        height: getProportionateScreenHeightMain(28),
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "You are currently swiping in ",
                        style: TextStyle(
                          fontSize: getProportionalFontSizeMain(11),
                          fontFamily: 'poppins',
                          color: Helper.hexToColor("#A1A1A1"),
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: "${mode}".toLowerCase(),
                            style: TextStyle(
                              fontSize: getProportionalFontSizeMain(11),
                              fontFamily: 'poppins',
                              color: Helper.hexToColor("#A1A1A1"),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: " mode",
                            style: TextStyle(
                              fontSize: getProportionalFontSizeMain(11),
                              fontFamily: 'poppins',
                              color: Helper.hexToColor("#A1A1A1"),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () async {
                      final result = await Navigator.pushNamed(
                          context, '/FeedsFilter',
                          arguments: new RouteArgument(
                              filterData: this._con.sendData));
                      if (result != null) {
                        print(result.toString());
                        _con.sendData = result as Feed;
                        _con.list_feeds.clear();
                        setState(() {});
                        _con.getFeeds();
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: getProportionateScreenHeightMain(60),
                          right: getProportionateScreenWidthMain(26.08)),
                      child: SvgPicture.asset("assets/images/filter_icon.svg"),
                    ),
                  ),
                )
              ],
            ),
            Container(
              height: getProportionateScreenHeightMain(18),
            ),
            IgnorePointer(
              ignoring: !_con.isNext ? true : false,
              child: _con.list_feeds.length > 0
                  ? Container(
                      height: getProportionateScreenHeightMain(507),
                      child: TinderSwapCard(
                        cardController: _cardController,
                        swipeUp: false,
                        swipeDown: false,
                        orientation: AmassOrientation.bottom,
                        totalNum: _con.list_feeds.length,
                        stackNum: 3,
                        swipeEdge: 4.0,
                        maxWidth: MediaQuery.of(context).size.width * 0.85,
                        maxHeight: MediaQuery.of(context).size.height * 0.7,
                        minWidth: MediaQuery.of(context).size.width * 0.82,
                        minHeight: MediaQuery.of(context).size.height * 0.5,
                        cardBuilder: (context, index) {
                          Size textSize;
                          double widthCustom;
                          textSize = Helper.textSize(
                              "${_con.list_feeds[index].name}, ${_con.list_feeds[index].birthdate}",
                              TextStyle(
                                  fontSize: getProportionalFontSizeMain(24),
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white));
                          if (textSize.width >
                              (MediaQuery.of(context).size.width * 0.65)) {
                            widthCustom =
                                MediaQuery.of(context).size.width * 0.65;
                          } else {
                            if (textSize.width <
                                (MediaQuery.of(context).size.width * 0.50)) {
                              widthCustom =
                                  MediaQuery.of(context).size.width * 0.45;
                            } else {
                              widthCustom = textSize.width;
                            }
                          }
                          return CachedNetworkImage(
                            imageUrl: '${_con.list_feeds[index].profile_img}',
                            fit: BoxFit.cover,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    getProportionateScreenWidthMain(30)),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(
                                          getProportionateScreenWidthMain(30)),
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/FeedsDetails',
                                          arguments: new RouteArgument(
                                              isMatches: false,
                                              FeedId: _con.list_feeds[index].id,
                                              isNormal: false),
                                        );
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                  getProportionateScreenWidthMain(
                                                      30)),
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/homeshadow.png'),
                                                  fit: BoxFit.cover)),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                bottom: 0,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left:
                                                          getProportionateScreenWidthMain(
                                                              23),
                                                      right:
                                                          getProportionateScreenWidthMain(
                                                              23),
                                                      bottom:
                                                          getProportionateScreenHeightMain(
                                                              26)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: widthCustom + 25,
                                                        child: Stack(
                                                          children: [
                                                            if (_con
                                                                .list_feeds[
                                                                    index]
                                                                .isVerified)
                                                              Positioned(
                                                                right: 0,
                                                                top: 0,
                                                                child:
                                                                    Image.asset(
                                                                  "assets/images/verified.png",
                                                                  width: 16,
                                                                  height: 16,
                                                                ),
                                                              ),
                                                            Container(
                                                              width:
                                                                  widthCustom,
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .fitWidth,
                                                                child: Text(
                                                                    "${_con.list_feeds[index].name}, ${_con.list_feeds[index].birthdate}",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        fontSize: getProportionalFontSizeMain(
                                                                            24),
                                                                        fontFamily:
                                                                            'poppins',
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: Colors
                                                                            .white)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        height:
                                                            getProportionateScreenHeightMain(
                                                                10),
                                                      ),
                                                      Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                            "${_con.list_feeds[index].address}",
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    getProportionalFontSizeMain(
                                                                        16),
                                                                fontFamily:
                                                                    'poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                      Container(
                                                        height:
                                                            getProportionateScreenHeightMain(
                                                                5),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.72,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                            "${_con.list_feeds[index].about_me}",
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    getProportionalFontSizeMain(
                                                                        12),
                                                                fontFamily:
                                                                    'poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                  !_con.isNext
                                      ? Positioned(
                                          bottom: 0,
                                          right: 0,
                                          top: 0,
                                          left: 0,
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            getProportionateScreenWidthMain(
                                                                30))),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          getProportionateScreenWidthMain(
                                                              30)),
                                                  child: SvgPicture.asset(
                                                    'assets/images/transparentgray.svg',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left:
                                                          getProportionateScreenWidthMain(
                                                              25),
                                                      right:
                                                          getProportionateScreenWidthMain(
                                                              25)),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      "You have used your 10 FREE swipes a day limit. For unlimited swipes upgrage your plan to PREMIUM.",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize:
                                                              getProportionalFontSizeMain(
                                                                  18),
                                                          fontFamily: 'poppins',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          );
                        },
                        swipeUpdateCallback:
                            (DragUpdateDetails details, Alignment align) {
                          /// Get swiping card's alignment
                          if (align.x < 0) {
                            //Card is LEFT swiping
                          } else if (align.x > 0) {
                            //Card is RIGHT swiping
                          }
                        },
                        swipeCompleteCallback:
                            (CardSwipeOrientation orientation, int index) {
                          if (orientation == CardSwipeOrientation.recover) {
                            return;
                          }
                          if (orientation == CardSwipeOrientation.left) {
                            _con.sendSwipe.swipe = "0";
                            _con.sendSwipe.receiver_id =
                                _con.list_feeds[index].id;
                            _con.feedSwipe(false);
                          } else if (orientation ==
                              CardSwipeOrientation.right) {
                            _con.sendSwipe.swipe = "1";
                            _con.sendSwipe.receiver_id =
                                _con.list_feeds[index].id;
                            _con.feedSwipe(false);
                          }
                          if (_con.list_feeds.length == index + 1) {
                            _con.list_feeds.clear();
                            setState(() {});
                          }
                          /*if (index == 5) {
                            Navigator.pushNamed(context, '/Match');
                          }*/

                          /// Get orientation & index of swiped card
                        },
                      ),
                    )
                  : !_con.isLoading
                      ? Container(
                          height: getProportionateScreenHeightMain(507),
                          child: Center(
                            child: Text("No user found",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: getProportionalFontSizeMain(25),
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w700,
                                    color: Helper.hexToColor("#5BAEE2"))),
                          ),
                        )
                      : Container(),
            ),
            Container(
              height: getProportionateScreenHeightMain(25),
            ),
            !_con.isNext
                ? GestureDetector(
                    onTap: () async {
                      final result =
                          await Navigator.pushNamed(context, '/PremiumPlan');
                      if (result != null) {
                        _con.getFeeds();
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: getProportionateScreenWidthMain(60),
                          right: getProportionateScreenWidthMain(60)),
                      child: Image.asset(
                        "assets/images/buttonupgradetoprime.png",
                        height: getProportionateScreenHeightMain(50),
                      ),
                    ),
                  )
                : _con.list_feeds.length > 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _cardController.triggerLeft();
                            },
                            child: Container(
                              child: Image.asset(
                                'assets/images/noicon.png',
                                width: getProportionateScreenWidthMain(75),
                                height: getProportionateScreenWidthMain(75),
                              ),
                            ),
                          ),
                          Container(
                            width: getProportionateScreenWidthMain(12),
                          ),
                          GestureDetector(
                            onTap: () {
                              _cardController.triggerRight();
                            },
                            child: Container(
                              child: Image.asset(
                                'assets/images/yesicon.png',
                                width: getProportionateScreenWidthMain(75),
                                height: getProportionateScreenWidthMain(75),
                              ),
                            ),
                          )
                        ],
                      )
                    : Container()
            /*_con.list_feeds.length > 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _cardController.triggerLeft();
                        },
                        child: Container(
                          child: Image.asset(
                            'assets/images/noicon.png',
                            width: getProportionateScreenWidthMain(75),
                            height: getProportionateScreenWidthMain(75),
                          ),
                        ),
                      ),
                      Container(
                        width: getProportionateScreenWidthMain(12),
                      ),
                      GestureDetector(
                        onTap: () {
                          _cardController.triggerRight();
                        },
                        child: Container(
                          child: Image.asset(
                            'assets/images/yesicon.png',
                            width: getProportionateScreenWidthMain(75),
                            height: getProportionateScreenWidthMain(75),
                          ),
                        ),
                      )
                    ],
                  )
                : Container(),*/
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/SentRequestController.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/SentRequest.dart';
import 'package:neuro/Models/route_arguments.dart';
import 'package:neuro/Widget/Countdown.dart';

class MessageSentRequestView extends StatefulWidget {
  @override
  _MessageSentRequestState createState() => _MessageSentRequestState();
}

class _MessageSentRequestState extends StateMVC<MessageSentRequestView> {
  late SentRequestController _con;

  _MessageSentRequestState() : super(SentRequestController()) {
    _con = controller as SentRequestController;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      _con.getSentRequestList(false);
    });
  }

  Future<void> _pullRefresh() async {
    _con.list_data.clear();
    _con.isLoading = true;
    setState(() {});
    _con.getSentRequestList(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: new Container(
        // color: Helper.hexToColor("#E5E5E5"),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: getProportionateScreenWidth(30),
                  right: getProportionateScreenWidth(18)),
              height: getProportionateScreenHeight(40),
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                  colors: [
                    Helper.hexToColor("#FFD600"),
                    Helper.hexToColor("#F26336"),
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text("Nudges left: ${_con.userNudgeCount}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: getProportionalFontSize(12),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w700,
                            color: Helper.hexToColor("#ffffff"))),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final result =
                          await Navigator.pushNamed(context, '/BuyNudege');
                      if (result != null) {
                        _con.list_data.clear();
                        setState(() {});
                        _con.getSentRequestList(false);
                      }
                    },
                    child: Container(
                      child: SvgPicture.asset(
                        'assets/images/button_buy_nudge.svg',
                        height: getProportionateScreenHeight(25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _con.list_data.length > 0
                  ? RefreshIndicator(
                      color: Helper.hexToColor("#5BAEE2"),
                      onRefresh: _pullRefresh,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        addRepaintBoundaries: false,
                        itemBuilder: (_, int index) {
                          return UserSentRequestView(
                              _con.list_data[index], _con);
                        },
                        itemCount: _con.list_data.length,
                      ),
                    )
                  : !_con.isLoading
                      ? Container(
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height,
                          margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).padding.bottom),
                          child: Center(
                            child: Text("No sent request found",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: getProportionalFontSize(20),
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w700,
                                    color: Helper.hexToColor("#5BAEE2"))),
                          ),
                        )
                      : Container(),
            ),
          ],
        ),
      ),
    );
  }
}

class UserSentRequestView extends StatefulWidget {
  SentRequest data;
  SentRequestController con;

  UserSentRequestView(this.data, this.con);

  @override
  _UserSentState createState() => _UserSentState(this.data, this.con);
}

class _UserSentState extends StateMVC<UserSentRequestView>
    with AutomaticKeepAliveClientMixin {
  SentRequest data;
  SentRequestController con;

  _UserSentState(this.data, this.con);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/FeedsDetails',
            arguments: new RouteArgument(
                isMatches: false, FeedId: this.data.user_id, isNormal: true));
      },
      child: new Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: getProportionateScreenHeight(2)),
        padding: EdgeInsets.only(
            left: getProportionateScreenWidth(30),
            right: getProportionateScreenWidth(16),
            top: getProportionateScreenHeight(18),
            bottom: getProportionateScreenHeight(18)),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80.0),
                    child: Container(
                      width: getProportionateScreenWidth(80),
                      height: getProportionateScreenWidth(80),
                      child: CachedNetworkImage(
                          width: getProportionateScreenWidth(80),
                          height: getProportionateScreenWidth(80),
                          fit: BoxFit.cover,
                          imageUrl: data.profile_img),
                    ),
                  ),
                ),
                Container(
                  width: getProportionateScreenWidth(26),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("${data.name}, ${data.birthdate}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: getProportionalFontSize(14),
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w700,
                              color: Helper.hexToColor("#3D3B3B"))),
                    ),
                    Container(
                      height: getProportionateScreenHeight(2),
                    ),
                    Container(
                      child: Text("${data.address}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: getProportionalFontSize(11),
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w600,
                              color: Helper.hexToColor("#A1A1A1"))),
                    ),
                    Container(
                      height: getProportionateScreenHeight(5),
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text("You sent",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: getProportionalFontSize(12),
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w500,
                                  color: Helper.hexToColor("#3D3B3B"))),
                        ),
                        Container(
                          child: Text(" Neuro Request!",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: getProportionalFontSize(12),
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.bold,
                                  color: Helper.hexToColor("#3D3B3B"))),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      this.con.sendNudge.id = data.user_id;
                      this.con.sendNudgeRequest();
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: getProportionateScreenHeight(30)),
                      child: Image.asset(
                        "assets/images/nudge.png",
                        height: getProportionateScreenHeight(25),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.only(
                        top: getProportionateScreenHeight(70),
                        right: getProportionateScreenWidth(5)),
                    child: CountdownFormatted(
                      duration: data.time!,
                      builder: (BuildContext ctx, String remaining) {
                        return Text(remaining,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: getProportionalFontSize(12),
                                fontFamily: 'poppins',
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w600,
                                color: Helper.hexToColor("#5BAEE2")));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

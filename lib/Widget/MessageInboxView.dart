import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/SentRequestController.dart';
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Helper/FirebaseManager.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/MessageUser.dart';
import 'package:neuro/Models/route_arguments.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Countdown.dart';

class MessageInboxView extends StatefulWidget {
  @override
  _MessageInboxState createState() => _MessageInboxState();
}

class _MessageInboxState extends StateMVC<MessageInboxView> {
  String? currentUserId = "";
  List<MessageUser>? temp_list_user = <MessageUser>[];
  bool isLoading = true;

  void callback() {
    isLoading = true;
    setState(() {});
    FirebaseManager().list_users!.sort((a, b) {
      return (b.time!.compareTo(a.time!));
    });
    temp_list_user = (FirebaseManager().list_users!);

    isLoading = false;
    setState(() {});
  }

  _getData() async {
    var prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getString(Constant.USERID) ?? '';
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    FirebaseManager().callback = this.callback;
    callback();
    _getData();
    Future.delayed(const Duration(milliseconds: 300), () {
      _con.getSentRequestList(true);
    });
  }

  late SentRequestController _con;

  _MessageInboxState() : super(SentRequestController()) {
    _con = controller as SentRequestController;
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
                    Helper.hexToColor("#C078BA"),
                    Helper.hexToColor("#5BAEE2"),
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        child: Text("Nudges left: ",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: getProportionalFontSize(10),
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w700,
                                color: Helper.hexToColor("#ffffff"))),
                      ),
                      Container(
                        child: Text("${_con.userNudgeCount}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: getProportionalFontSize(12),
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w700,
                                color: Helper.hexToColor("#ffffff"))),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      final result =
                          await Navigator.pushNamed(context, '/BuyNudege');
                          //await Navigator.pushNamed(context, '/TestPurchase');
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
                child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) => UserViewMessage(
                  context,
                  temp_list_user![index],
                  currentUserId!,
                  _con,
                  _con.userNudgeCount),
              itemCount: temp_list_user!.length,
            ))
          ],
        ),
      ),
    );
  }
}

class UserViewMessage extends StatelessWidget {
  BuildContext context;
  MessageUser data;
  String userId;
  SentRequestController con;
  String userNudgeCount;

  UserViewMessage(
      this.context, this.data, this.userId, this.con, this.userNudgeCount);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/FirebaseChat',
            arguments: new RouteArgument(userChat: this.data));
      },
      child: new Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: getProportionateScreenHeight(2)),
        padding: EdgeInsets.only(
            left: getProportionateScreenWidth(30),
            right: getProportionateScreenWidth(30),
        ),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: getProportionateScreenHeight(25),
                  bottom: getProportionateScreenHeight(25)),
              child: Row(
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80.0),
                      child: Container(
                        width: getProportionateScreenWidth(50),
                        height: getProportionateScreenWidth(50),
                        child: CachedNetworkImage(
                            width: getProportionateScreenWidth(50),
                            height: getProportionateScreenWidth(50),
                            fit: BoxFit.cover,
                            imageUrl: this.data.photoUrl!),
                      ),
                    ),
                  ),
                  Container(
                    width: getProportionateScreenWidth(12),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Text(this.data.nickname!,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: getProportionalFontSize(14),
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w700,
                                color: Helper.hexToColor("#3D3B3B"))),
                      ),
                      Container(
                        height: getProportionateScreenHeight(5),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.60,
                        child: Text(
                            this.data.type! == "1"
                                ? "Image"
                                : this.data.type! == "2"
                                    ? "Voice"
                                    : this.data.message!,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: getProportionalFontSize(11),
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w500,
                                color: Helper.hexToColor("#767272"))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.only(top: getProportionateScreenHeight(12)),
                    child: Text(Helper.dayFormatter(this.data.time!),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: getProportionalFontSize(11),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: Helper.hexToColor("#A8A7A7"))),
                  ),
                ),
                this.data.count != ""
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: getProportionateScreenHeight(27)),
                          width: getProportionateScreenWidth(18),
                          height: getProportionateScreenWidth(18),
                          decoration: new BoxDecoration(
                            color: Helper.hexToColor("#5BAEE2"),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                              this.data.count,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: getProportionalFontSize(8),
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w600,
                                  color: Helper.hexToColor("#ffffff"))),
                        ),
                      )
                    : Container(),
                data.nudgeSender != null
                    ? Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: getProportionateScreenHeight(40),
                        ),
                        width: getProportionateScreenWidth(70),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (!this.data.isNudgeSent) {
                                  if (this.userNudgeCount != "0") {
                                    this.con.sendNudge.id = this.data.id!;
                                    this.con.sendNudgeRequest();
                                  }
                                  var documentrecentPeerId = FirebaseFirestore
                                      .instance
                                      .collection('recentusers')
                                      .doc(this.data.id)
                                      .collection(this.data.id!)
                                      .doc(userId);

                                  var mapData = Map<String, Object>();
                                  mapData['isNudgeSent'] = true;
                                  await FirebaseFirestore.instance
                                      .runTransaction((transaction) async {
                                    transaction.update(
                                        documentrecentPeerId, mapData);
                                  });

                                  var documentrecent = FirebaseFirestore
                                      .instance
                                      .collection('recentusers')
                                      .doc(userId)
                                      .collection(userId)
                                      .doc(this.data.id);
                                  await FirebaseFirestore.instance
                                      .runTransaction((transaction) async {
                                    transaction.update(
                                        documentrecent, mapData);
                                  });
                                }
                              },
                              child: Container(
                                child: Image.asset(
                                  this.data.isNudgeSent
                                      ? "assets/images/nudge_sent.png"
                                      : "assets/images/nudge.png",
                                  height: getProportionateScreenHeight(25),
                                ),
                              ),
                            ),
                            Container(
                              height: getProportionateScreenHeight(8),
                            ),
                            CountdownFormatted(
                              duration: data.nudgeSender!,
                              builder: (BuildContext ctx, String remaining) {
                                return Text(remaining,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: getProportionalFontSize(12),
                                        fontFamily: 'poppins',
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                        color: Helper.hexToColor("#C078BA")));
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/NeuroRequestController.dart';
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Matches.dart';
import 'package:neuro/Models/NeuroRequest.dart';
import 'package:neuro/Models/route_arguments.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Countdown.dart';

class MessageNeuroRequestView extends StatefulWidget {
  @override
  _MessageNeuroRequestState createState() => _MessageNeuroRequestState();
}

class _MessageNeuroRequestState extends StateMVC<MessageNeuroRequestView> {
  late NeuroRequestController _con;

  _MessageNeuroRequestState() : super(NeuroRequestController()) {
    _con = controller as NeuroRequestController;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      _con.getNeuroRequestList();
    });
  }

  Future<void> _pullRefresh() async {
    _con.list_data.clear();
    _con.isLoading = true;
    setState(() { });
    _con.getNeuroRequestList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: _con.list_data.length > 0
          ? RefreshIndicator(
            color: Helper.hexToColor("#5BAEE2"),
            onRefresh: _pullRefresh,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (_, int index) {
                return UserNeuroView(_con.list_data[index], _con, index);
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
                    child: Text("No neuro request found",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: getProportionalFontSize(20),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w700,
                            color: Helper.hexToColor("#5BAEE2"))),
                  ),
                )
              : Container(),
    );
  }
}

class UserNeuroView extends StatefulWidget {
  NeuroRequest data;
  NeuroRequestController con;
  int index;

  UserNeuroView(this.data, this.con, this.index);

  @override
  _UserNeuroView createState() => _UserNeuroView(this.data, this.con);
}

class _UserNeuroView extends StateMVC<UserNeuroView>
    with AutomaticKeepAliveClientMixin {
  NeuroRequest data;
  NeuroRequestController con;

  _UserNeuroView(this.data, this.con);

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
            right: getProportionateScreenWidth(30),
            top: getProportionateScreenHeight(18),
            bottom: getProportionateScreenHeight(15)),
        child: Column(
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
                      child: Text(data.address,
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
                          child: Text("Sent you",
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
            Container(
              height: getProportionateScreenHeight(17),
            ),
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        var pref = await SharedPreferences.getInstance();
                        this.con.sendData.id = data.user_id;
                        this.con.sendData.type = "1";

                        Matches sendData = new Matches();
                        sendData.ToImage = data.profile_img;
                        sendData.FromImage =
                            pref.getString(Constant.PROFILEIMAGE)!;
                        sendData.name = data.name;
                        sendData.id = data.user_id;
                        this
                            .con
                            .acceptReject(this.con.sendData, data, sendData);
                      },
                      child: Container(
                        child: Image.asset(
                          'assets/images/yesicon.png',
                          width: getProportionateScreenWidth(50),
                          height: getProportionateScreenWidth(50),
                        ),
                      ),
                    ),
                    Container(
                      width: getProportionateScreenWidth(12),
                    ),
                    GestureDetector(
                      onTap: () {
                        this.con.sendData.id = data.user_id;
                        this.con.sendData.type = "2";
                        this.con.acceptReject(this.con.sendData, data);
                      },
                      child: Container(
                        child: Image.asset(
                          'assets/images/noicon.png',
                          width: getProportionateScreenWidth(50),
                          height: getProportionateScreenWidth(50),
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.only(
                        top: getProportionateScreenHeight(49),
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

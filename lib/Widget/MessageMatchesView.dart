import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/MatcheController.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Matches.dart';
import 'package:neuro/Models/MessageUser.dart';
import 'package:neuro/Models/route_arguments.dart';

class MessageMatchesView extends StatefulWidget {
  @override
  _MessageMatchesState createState() => _MessageMatchesState();
}

class _MessageMatchesState extends StateMVC<MessageMatchesView> {
  late MatcheController _con;

  _MessageMatchesState() : super(MatcheController(true)) {
    _con = controller as MatcheController;
  }

  Future<void> _pullRefresh() async {
    _con.list_data.clear();
    _con.isLoading = true;
    setState(() {});
    _con.getMatchList();
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
                  return UserMatchesView(_con.list_data[index], _con);
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
                    child: Text("No matches found",
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

class UserMatchesView extends StatelessWidget {
  Matches data;
  MatcheController _con;

  UserMatchesView(this.data, this._con);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/FeedsDetails',
            arguments: new RouteArgument(
                isMatches: true, FeedId: data.id, isNormal: false));
      },
      child: new Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: getProportionateScreenHeight(2)),
        padding: EdgeInsets.only(
            left: getProportionateScreenWidth(30),
            right: getProportionateScreenWidth(30),
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
                  width: getProportionateScreenWidth(28),
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
                    Container(
                      child: Row(
                        children: [
                          Text("You have ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: getProportionalFontSize(12),
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w500,
                                  color: Helper.hexToColor("#3D3B3B"))),
                          Text("a Match!",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: getProportionalFontSize(12),
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w600,
                                  color: Helper.hexToColor("#3D3B3B"))),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () async {
                  MessageUser userChat =
                      new MessageUser(data.id, data.profile_img, data.name);
                  final result = await Navigator.pushNamed(
                      context, '/FirebaseChat',
                      arguments: new RouteArgument(
                          userChat: userChat, isMatches: true));
                  if (result != null) {
                    _con.refreshList();
                  }
                },
                child: Container(
                  margin:
                      EdgeInsets.only(top: getProportionateScreenHeight(15)),
                  width: getProportionateScreenWidth(52),
                  height: getProportionateScreenWidth(52),
                  child: Image.asset(
                    "assets/images/shadow_message_icon.png",
                    width: getProportionateScreenWidth(52),
                    height: getProportionateScreenWidth(52),
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

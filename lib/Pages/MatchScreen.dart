import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/MessageUser.dart';
import 'package:neuro/Models/route_arguments.dart';
import 'package:neuro/ThirdParty/assorted_layout_widget/assorted_layout_widgets.dart';

class MatchScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  MatchScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _MatchState createState() => _MatchState();
}

class _MatchState extends StateMVC<MatchScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin:
                        EdgeInsets.only(top: getProportionateScreenHeightMain(56)),
                    child: SvgPicture.asset(
                      "assets/images/neurowhite.svg",
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, top: 60),
                        child: SvgPicture.asset(
                          "assets/images/left_arrow.svg",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: getProportionateScreenHeightMain(111),
            ),
            Container(
              child: RowSuper(
                innerDistance: -35.0,
                invert: true,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Helper.hexToColor("#ffffff"), width: 3),
                      borderRadius: BorderRadius.circular(150.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(150.0),
                      child: Container(
                        width: getProportionateScreenWidthMain(150),
                        height: getProportionateScreenWidthMain(150),
                        child: CachedNetworkImage(
                            width: getProportionateScreenWidthMain(150),
                            height: getProportionateScreenWidthMain(150),
                            fit: BoxFit.cover,
                            imageUrl:
                                this.widget.routeArgument!.matches!.FromImage),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Helper.hexToColor("#ffffff"), width: 3),
                      borderRadius: BorderRadius.circular(150.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(150.0),
                      child: Container(
                        width: getProportionateScreenWidthMain(150),
                        height: getProportionateScreenWidthMain(150),
                        child: CachedNetworkImage(
                            width: getProportionateScreenWidthMain(150),
                            height: getProportionateScreenWidthMain(150),
                            fit: BoxFit.cover,
                            imageUrl:
                                this.widget.routeArgument!.matches!.ToImage),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: getProportionateScreenHeightMain(52),
            ),
            Container(
              child: SvgPicture.asset("assets/images/its _a.svg"),
            ),
            Container(
              height: getProportionateScreenHeightMain(12),
            ),
            Container(
              child: SvgPicture.asset("assets/images/match_text.svg"),
            ),
            Container(
              height: getProportionateScreenHeightMain(244),
            ),
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                MessageUser userChat = new MessageUser(
                    this.widget.routeArgument!.matches!.id,
                    this.widget.routeArgument!.matches!.ToImage,
                    this.widget.routeArgument!.matches!.name);
                final result = await Navigator.pushNamed(
                    context, '/FirebaseChat',
                    arguments:
                        new RouteArgument(userChat: userChat, isMatches: true));
              },
              child: Container(
                child:
                    SvgPicture.asset("assets/images/send_message_button.svg"),
              ),
            ),
            /*GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(top: getProportionateScreenHeightMain(29)),
                alignment: Alignment.center,
                child: Text("keep swiping".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: getProportionalFontSize(14),
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.w600,
                        color: Helper.hexToColor("#ffffff"))),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/GroupController.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Group.dart';
import 'package:neuro/Models/route_arguments.dart';

class GroupInfoScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  GroupInfoScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _GroupInfoState createState() => _GroupInfoState();
}

class _GroupInfoState extends StateMVC<GroupInfoScreen> {
  late GroupController _con;

  _GroupInfoState() : super(GroupController()) {
    _con = controller as GroupController;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      _con.sendDataGroupInfo.id = this.widget.routeArgument!.groupID!;
      _con.getGroupInfo();
    });
  }

  _editProfile() async {
    final result = await Navigator.pushNamed(context, '/EditGroupInfo',
        arguments: new RouteArgument(groupInfo: _con.data));
    if (result != null) {
      _con.sendDataGroupInfo.id = this.widget.routeArgument!.groupID!;
      _con.getGroupInfo();
    }
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
        actions: [
          _con.data.admin
              ? GestureDetector(
                  onTap: () async {
                    _editProfile();
                  },
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Icon(
                        Icons.edit,
                        color: Helper.hexToColor("#5BAEE2"),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
        elevation: 0,
        centerTitle: false,
        title: Text(
          _con.data.group_name,
          style: TextStyle(
              fontSize: getProportionalFontSize(14),
              fontFamily: 'poppins',
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
      body: !_con.isLoading
          ? SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: getProportionateScreenHeight(34)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80.0),
                        child: Container(
                          width: getProportionateScreenWidth(80),
                          height: getProportionateScreenWidth(80),
                          child: CachedNetworkImage(
                              width: getProportionateScreenWidth(80),
                              height: getProportionateScreenWidth(80),
                              fit: BoxFit.cover,
                              imageUrl: _con.data.group_img),
                        ),
                      ),
                    ),
                    Container(
                      height: getProportionateScreenHeight(16),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          left: getProportionateScreenWidth(30),
                          right: getProportionateScreenWidth(30)),
                      child: Text(
                        _con.data.group_name,
                        style: TextStyle(
                            fontSize: getProportionalFontSize(14),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Container(
                      height: getProportionateScreenHeight(4),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          left: getProportionateScreenWidth(30),
                          right: getProportionateScreenWidth(30)),
                      child: Text(
                        _con.data.about,
                        style: TextStyle(
                            fontSize: getProportionalFontSize(11),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: Helper.hexToColor("#A1A1A1")),
                      ),
                    ),
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
                      child: Text(
                        "Members",
                        style: TextStyle(
                            fontSize: getProportionalFontSize(10),
                            letterSpacing: 1.68,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w700,
                            color: Helper.hexToColor("#3D3B3B")),
                      ),
                    ),
                    Container(
                      height: getProportionateScreenHeight(18),
                    ),
                    _con.data.admin
                        ? InkWell(
                            onTap: () {
                              _editProfile();
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: getProportionateScreenWidth(30),
                                  right: getProportionateScreenWidth(30)),
                              child: Row(
                                children: [
                                  Container(
                                    child: SvgPicture.asset(
                                      'assets/images/add_roundbutton.svg',
                                      height: getProportionateScreenWidth(50),
                                      width: getProportionateScreenWidth(50),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: getProportionateScreenWidth(20),
                                    ),
                                    child: Text(
                                      "Add Members",
                                      style: TextStyle(
                                          fontSize: getProportionalFontSize(12),
                                          fontFamily: 'poppins',
                                          fontWeight: FontWeight.w600,
                                          color: Helper.hexToColor("#5BAEE2")),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (_, int index) {
                        Group data = _con.data.group_members[index];
                        return new Container(
                          margin: EdgeInsets.only(
                              top: getProportionateScreenHeight(14),
                              left: getProportionateScreenWidth(30),
                              right: getProportionateScreenWidth(30)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(80.0),
                                      child: Container(
                                        width: getProportionateScreenWidth(50),
                                        height: getProportionateScreenWidth(50),
                                        child: CachedNetworkImage(
                                            width:
                                                getProportionateScreenWidth(50),
                                            height:
                                                getProportionateScreenWidth(50),
                                            fit: BoxFit.cover,
                                            imageUrl: data.profile_img),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: getProportionateScreenWidth(20),
                                    ),
                                    child: Text(
                                      data.name,
                                      style: TextStyle(
                                          fontSize: getProportionalFontSize(14),
                                          fontFamily: 'poppins',
                                          fontWeight: FontWeight.w600,
                                          color: Helper.hexToColor("#3D3B3B")),
                                    ),
                                  ),
                                ],
                              ),
                              data.admin
                                  ? Container(
                                      child: SvgPicture.asset(
                                        'assets/images/admin_indicator.svg',
                                        height: getProportionateScreenWidth(25),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        );
                      },
                      itemCount: _con.data.group_members.length,
                    )
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}

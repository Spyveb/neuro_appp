import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/GroupController.dart';
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/FirebaseUser.dart';
import 'package:neuro/Models/GroupRequest.dart';
import 'package:neuro/Models/NeuroRequest.dart';
import 'package:neuro/ThirdParty/assorted_layout_widget/assorted_layout_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupMessageRequestView extends StatefulWidget {
  @override
  _GroupMessageRequestState createState() => _GroupMessageRequestState();
}

class _GroupMessageRequestState extends StateMVC<GroupMessageRequestView> {
  late GroupController _con;

  _GroupMessageRequestState() : super(GroupController()) {
    _con = controller as GroupController;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      _con.getGroupRequestList();
    });
  }

  Future<void> _pullRefresh() async {
    _con.list_data.clear();
    _con.isLoading = true;
    setState(() {});
    _con.getGroupRequestList();
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
                    return GroupViewRequest(_con.list_data[index], index, _con);
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
                      child: Text("No group request found",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: getProportionalFontSize(20),
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w700,
                              color: Helper.hexToColor("#5BAEE2"))),
                    ),
                  )
                : Container());
  }
}

class GroupViewRequest extends StatefulWidget {
  GroupRequest data;
  int index;
  GroupController con;

  GroupViewRequest(this.data, this.index, this.con);

  @override
  _GroupViewState createState() =>
      _GroupViewState(this.data, this.con, this.index);
}

class _GroupViewState extends StateMVC<GroupMessageRequestView> {
  GroupRequest data;
  GroupController con;
  int index;

  _GroupViewState(this.data, this.con, this.index);

  int count = 0;
  List<dynamic> images = <dynamic>[];

  @override
  void initState() {
    super.initState();
    if (this.data.image.length > 3) {
      for (int i = 0; i < this.data.image.length; i++) {
        if (i <= 2) {
          images.add(this.data.image[i]);
        } else {
          count++;
        }
      }
      images.add("");
    } else {
      images = this.data.image;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: getProportionateScreenHeight(2)),
      padding: EdgeInsets.only(
          left: getProportionateScreenWidth(30),
          right: getProportionateScreenWidth(30),
          top: getProportionateScreenHeight(18),
          bottom: getProportionateScreenHeight(18)),
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
                        imageUrl: this.data.group_img),
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
                    child: Text("${data.group_name}",
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
                    child: Text(data.about,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: getProportionalFontSize(11),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: Helper.hexToColor("#A1A1A1"))),
                  ),
                  Container(
                    height: getProportionateScreenHeight(10),
                  ),
                  Container(
                    child: RowSuper(
                      innerDistance: -8.0,
                      invert: true,
                      children: images.map((i) {
                        return i != ""
                            ? Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Helper.hexToColor("#ffffff")),
                                  borderRadius: BorderRadius.circular(80.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(80.0),
                                  child: Container(
                                    width: getProportionateScreenWidth(24),
                                    height: getProportionateScreenWidth(24),
                                    child: CachedNetworkImage(
                                        width: getProportionateScreenWidth(24),
                                        height: getProportionateScreenWidth(24),
                                        fit: BoxFit.cover,
                                        imageUrl: i),
                                  ),
                                ),
                              )
                            : Container(
                                alignment: Alignment.center,
                                width: getProportionateScreenWidth(24),
                                height: getProportionateScreenWidth(24),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Helper.hexToColor("#5BAEE2"),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(80.0),
                                ),
                                child: Text("+${count}",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: getProportionalFontSize(8),
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.w600,
                                        color: Helper.hexToColor("#5BAEE2"))),
                              );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            height: getProportionateScreenHeight(17.8),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String adminID = prefs.getString(Constant.USERID)!;
                  String adminName = prefs.getString(Constant.NAME)!;
                  String adminPhoto = prefs.getString(Constant.PROFILEIMAGE)!;

                  NeuroRequest sendData = new NeuroRequest();
                  sendData.id = data.id;
                  sendData.type = "1";
                  FirebaseUser dataUser = new FirebaseUser();
                  dataUser.id = adminID;
                  dataUser.name = adminName;
                  dataUser.image = adminPhoto;
                  dataUser.isAdmin = false;
                  await FirebaseFirestore.instance
                      .collection('groups')
                      .doc(data.id)
                      .update({
                    "members": FieldValue.arrayUnion([dataUser.toJson()])
                  });
                  var documentrecentReferencetoFrom = FirebaseFirestore.instance
                      .collection('recentgroups')
                      .doc(adminID)
                      .collection(adminID)
                      .doc(data.id.toString());
                  await FirebaseFirestore.instance
                      .runTransaction((transaction) async {
                    transaction.set(documentrecentReferencetoFrom, {
                      'content': "",
                      'type': 0,
                      'groupId': data.id.toString(),
                      'timestamp': DateTime.now().millisecondsSinceEpoch,
                    });
                  });
                  this.con.acceptReject(sendData, this.index);
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
                  NeuroRequest sendData = new NeuroRequest();
                  sendData.id = data.id;
                  sendData.type = "2";
                  this.con.acceptReject(sendData, this.index);
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
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/UserSelectionController.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/route_arguments.dart';

class UserSelectionScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  UserSelectionScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _UserSelectionState createState() => _UserSelectionState();
}

class _UserSelectionState extends StateMVC<UserSelectionScreen> {
  var searchCon = TextEditingController();

  late UserSelectionController _con;

  _UserSelectionState() : super(UserSelectionController()) {
    _con = controller as UserSelectionController;
  }

  onSearchTextChanged(String text) async {
    _con.list_data.clear();
    if (text.isEmpty) {
      _con.list_data.addAll(_con.main_list_data);
      setState(() {});
      return;
    }
    _con.main_list_data.forEach((element) {
      if (element.name.toLowerCase().contains(text.toLowerCase())) {
        _con.list_data.add(element);
      }
    });
    if (_con.list_data.length == 0) {
      _con.isLoading = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (this.widget.routeArgument!.groupID != null) {
        _con.sendData.groupID = this.widget.routeArgument!.groupID!;
      }
      _con.getFriendList(this.widget.routeArgument!.list_user);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Scaffold(
      key: _con.scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        leading: InkWell(
          onTap: () {
            var selectedData =
                _con.list_data.where((element) => element.isSelected).toList();
            Navigator.pop(context, selectedData);
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
          GestureDetector(
            onTap: () {
              var selectedData = _con.list_data
                  .where((element) => element.isSelected)
                  .toList();
              Navigator.pop(context, selectedData);
            },
            child: Container(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Icon(
                    Icons.check_outlined,
                    color: Helper.hexToColor("#5BAEE2"),
                  )),
            ),
          ),
        ],
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Users".toUpperCase(),
          style: TextStyle(
              fontSize: getProportionalFontSize(14),
              fontFamily: 'poppins',
              letterSpacing: 1.68,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                  height: getProportionateScreenHeight(39),
                  margin: EdgeInsets.only(
                      left: getProportionateScreenWidth(18),
                      right: getProportionateScreenWidth(18),
                      top: getProportionateScreenHeight(10)),
                  padding:
                      EdgeInsets.only(left: getProportionateScreenWidth(20)),
                  decoration: BoxDecoration(
                      color: Helper.hexToColor("#F9F8F7"),
                      border: Border.all(color: Helper.hexToColor("#DADADA")),
                      borderRadius: BorderRadius.all(Radius.circular(19.5))),
                  child: TextField(
                    controller: searchCon,
                    onChanged: onSearchTextChanged,
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          searchCon.clear();
                          setState(() {});
                          onSearchTextChanged("");
                        },
                        child: Container(
                          child: SvgPicture.asset(
                            "assets/images/close_icon.svg",
                            fit: BoxFit.none,
                            color: Helper.hexToColor("#5BAEE2"),
                            width: getProportionateScreenWidth(15),
                            height: getProportionateScreenWidth(15),
                          ),
                        ),
                      ),
                      border: InputBorder.none,
                      hintText: "Search here",
                      hintStyle: TextStyle(
                          height: 1.5,
                          fontSize: getProportionalFontSize(12),
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w400,
                          color: Helper.hexToColor("#AEAAA4")),
                    ),
                    style: TextStyle(
                        height: 1.5,
                        fontSize: getProportionalFontSize(12),
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.w500,
                        color: Helper.hexToColor("#000000")),
                  )),
              Expanded(
                child: _con.list_data.length > 0
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        addRepaintBoundaries: false,
                        itemBuilder: (_, int index) {
                          return new Container(
                            color: Colors.white,
                            margin: EdgeInsets.only(
                                top: getProportionateScreenHeight(2)),
                            padding: EdgeInsets.only(
                                left: getProportionateScreenWidth(16),
                                right: getProportionateScreenWidth(16),
                                top: getProportionateScreenHeight(18),
                                bottom: getProportionateScreenHeight(18)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Row(
                                    children: [
                                      Container(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(80.0),
                                          child: Container(
                                            width:
                                                getProportionateScreenWidth(80),
                                            height:
                                                getProportionateScreenWidth(80),
                                            child: CachedNetworkImage(
                                                width:
                                                    getProportionateScreenWidth(
                                                        80),
                                                height:
                                                    getProportionateScreenWidth(
                                                        80),
                                                fit: BoxFit.cover,
                                                imageUrl: _con.list_data[index]
                                                    .profile_img),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: getProportionateScreenWidth(12),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                                "${_con.list_data[index].name}, ${_con.list_data[index].birthdate}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontSize:
                                                        getProportionalFontSize(
                                                            14),
                                                    fontFamily: 'poppins',
                                                    fontWeight: FontWeight.w700,
                                                    color: Helper.hexToColor(
                                                        "#3D3B3B"))),
                                          ),
                                          Container(
                                            height:
                                                getProportionateScreenHeight(2),
                                          ),
                                          Container(
                                            child: Text(
                                                "${_con.list_data[index].address}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontSize:
                                                        getProportionalFontSize(
                                                            11),
                                                    fontFamily: 'poppins',
                                                    fontWeight: FontWeight.w600,
                                                    color: Helper.hexToColor(
                                                        "#A1A1A1"))),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (_con.list_data[index].isSelected) {
                                      _con.list_data[index].isSelected = false;
                                    } else {
                                      _con.list_data[index].isSelected = true;
                                    }
                                    setState(() {});
                                    if (this.widget.routeArgument!.isFromEdit ==
                                        true) {
                                      if (!_con.list_data[index].isSelected) {
                                        final Map<String, dynamic> dataDelete =
                                            new Map<String, dynamic>();
                                        dataDelete['id'] =
                                            _con.list_data[index].id;
                                        dataDelete['name'] =
                                            _con.list_data[index].name;
                                        dataDelete['image'] =
                                            _con.list_data[index].profile_img;
                                        dataDelete['isAdmin'] =
                                            _con.list_data[index].admin;

                                        await FirebaseFirestore.instance
                                            .collection('groups')
                                            .doc(this
                                                .widget
                                                .routeArgument!
                                                .groupID)
                                            .update({
                                          "members": FieldValue.arrayRemove(
                                              [dataDelete])
                                        });

                                        await FirebaseFirestore.instance
                                            .collection('recentgroups')
                                            .doc(_con.list_data[index].id)
                                            .collection(
                                                _con.list_data[index].id)
                                            .doc(this
                                                .widget
                                                .routeArgument!
                                                .groupID)
                                            .delete();

                                        _con.addRemoveSendData.group_id =
                                            this.widget.routeArgument!.groupID!;
                                        _con.addRemoveSendData.member_id =
                                            _con.list_data[index].id;
                                        _con.addRemoveSendData.isAdd = "1";

                                        _con.addRemoveUser();
                                      } else {
                                        _con.addRemoveSendData.group_id =
                                            this.widget.routeArgument!.groupID!;
                                        _con.addRemoveSendData.member_id =
                                            _con.list_data[index].id;
                                        _con.addRemoveSendData.isAdd = "0";
                                        _con.addRemoveUser();
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 12, right: 12),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Helper.hexToColor("#5BAEE2")),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(35))),
                                    child: Text(
                                        _con.list_data[index].isSelected
                                            ? "Remove"
                                            : "Add",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize:
                                                getProportionalFontSize(11),
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Helper.hexToColor("#5BAEE2"))),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: _con.list_data.length,
                      )
                    : !_con.isLoading
                        ? Container(
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height,
                            margin: EdgeInsets.only(
                                bottom: MediaQuery.of(context).padding.bottom),
                            child: Center(
                              child: Text("No friends found",
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
      ),
    );
  }
}

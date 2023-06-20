import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/GroupController.dart';
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/FriendUser.dart';
import 'package:neuro/Models/route_arguments.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditGroupInfo extends StatefulWidget {
  RouteArgument? routeArgument;

  EditGroupInfo({Key? key, this.routeArgument}) : super(key: key);

  @override
  _EditGroupState createState() => _EditGroupState();
}

class _EditGroupState extends StateMVC<EditGroupInfo> {
  late GroupController _con;

  _EditGroupState() : super(GroupController()) {
    _con = controller as GroupController;
  }

  File? _image;

  String adminPhoto = "";
  String adminName = "";

  getAdminData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    adminName = prefs.getString(Constant.NAME)!;
    adminPhoto = prefs.getString(Constant.PROFILEIMAGE)!;
    setState(() {});
  }

  _imgFromCamera() async {
    PickedFile? image =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform
            .pickImage(source: ImageSource.camera, imageQuality: 70,
            maxWidth: 300);

    setState(() {
      _image = new File(image!.path);
    });
  }

  _imgFromGallery() async {
    PickedFile? image =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform
            .pickImage(source: ImageSource.gallery, imageQuality: 70,
            maxWidth: 300);

    setState(() {
      _image = new File(image!.path);
    });
  }

  List<FriendUser> list_selected_member = <FriendUser>[];

  var groupNameCon = TextEditingController();
  var groupTopicCon = TextEditingController();

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  String image = "";

  @override
  void initState() {
    super.initState();
    if (this.widget.routeArgument!.groupInfo != null) {
      groupNameCon.text = this.widget.routeArgument!.groupInfo!.group_name;
      groupTopicCon.text = this.widget.routeArgument!.groupInfo!.about;
      image = this.widget.routeArgument!.groupInfo!.group_img;
      this.widget.routeArgument!.groupInfo!.group_members.forEach((element) {
        FriendUser data = new FriendUser();
        data.id = element.id;
        data.name = element.name;
        data.birthdate = element.age;
        data.profile_img = element.profile_img;
        data.address = element.address;
        data.admin = element.admin;
        list_selected_member.add(data);
      });
      setState(() {});
    }
    getAdminData();
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
            Navigator.pop(context, "1");
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
              if (groupNameCon.text.isEmpty) {
                Helper.showToast("Please enter group name");
                return;
              }
              if (groupTopicCon.text.isEmpty) {
                Helper.showToast("Please enter group topic");
                return;
              }
              if (list_selected_member.length == 0) {
                Helper.showToast("Please select member");
                return;
              }
              _con.sendData.group_id =
                  this.widget.routeArgument!.groupInfo!.id;
              _con.sendData.group_img = _image;
              _con.sendData.group_name = groupNameCon.text.toString();
              _con.sendData.about = groupTopicCon.text.toString();
              _con.updateGroup();
            },
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Icon(
                  Icons.save,
                  color: Helper.hexToColor("#5BAEE2"),
                ),
              ),
            ),
          )
        ],
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Edit Group",
          style: TextStyle(
              fontSize: getProportionalFontSize(14),
              letterSpacing: 1.68,
              fontFamily: 'poppins',
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: new Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: getProportionateScreenHeight(40),
              ),
              Container(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: Container(
                      height: getProportionateScreenWidth(122),
                      width: getProportionateScreenWidth(122),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(120.0)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(120.0)),
                        child: _image != null
                            ? Image.file(
                                _image!,
                                fit: BoxFit.cover,
                                height: getProportionateScreenWidth(122),
                                width: getProportionateScreenWidth(122),
                              )
                            : CachedNetworkImage(
                                imageUrl: image,
                                fit: BoxFit.cover,
                              ),
                      )),
                ),
              ),
              Container(
                height: getProportionateScreenHeight(28),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: getProportionateScreenWidth(30),
                    right: getProportionateScreenWidth(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("Group Name",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: getProportionalFontSize(14),
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w500,
                              color: Helper.hexToColor("#BFC5D9"))),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: groupNameCon,
                        decoration: InputDecoration(
                          border: new UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  width: 1,
                                  color: Helper.hexToColor("#E4E7F1"))),
                          focusedBorder: new UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  width: 1,
                                  color: Helper.hexToColor("#E4E7F1"))),
                          enabledBorder: new UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  width: 1,
                                  color: Helper.hexToColor("#E4E7F1"))),
                          hintText: "eg: Bus Trip",
                          hintStyle: TextStyle(
                              fontSize: getProportionalFontSize(14),
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w500,
                              color: Helper.hexToColor("#BFC5D9")),
                        ),
                        style: TextStyle(
                            fontSize: getProportionalFontSize(16),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: Helper.hexToColor("#393939")),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: getProportionateScreenHeight(24),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: getProportionateScreenWidth(30),
                    right: getProportionateScreenWidth(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("Group Topic",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: getProportionalFontSize(14),
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w500,
                              color: Helper.hexToColor("#BFC5D9"))),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: groupTopicCon,
                        decoration: InputDecoration(
                          border: new UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  width: 1,
                                  color: Helper.hexToColor("#E4E7F1"))),
                          focusedBorder: new UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  width: 1,
                                  color: Helper.hexToColor("#E4E7F1"))),
                          enabledBorder: new UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  width: 1,
                                  color: Helper.hexToColor("#E4E7F1"))),
                          hintText: "eg: Discuss Trip",
                          hintStyle: TextStyle(
                              fontSize: getProportionalFontSize(14),
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w500,
                              color: Helper.hexToColor("#BFC5D9")),
                        ),
                        style: TextStyle(
                            fontSize: getProportionalFontSize(16),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: Helper.hexToColor("#393939")),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: getProportionateScreenHeight(24),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: getProportionateScreenWidth(30),
                    right: getProportionateScreenWidth(30)),
                child: Text(
                  "Members",
                  style: TextStyle(
                      fontSize: getProportionalFontSize(10),
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w700,
                      color: Helper.hexToColor("#3D3B3B")),
                ),
              ),
              Container(
                height: getProportionateScreenHeight(18),
              ),
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.pushNamed(
                      context, "/UserSelection",
                      arguments:
                          new RouteArgument(list_user: list_selected_member,groupID: this.widget.routeArgument!.groupInfo!.id,isFromEdit: true));
                  if (result != null) {
                    list_selected_member.clear();
                    list_selected_member = (result as List<FriendUser>);
                    setState(() {});
                    print((result).length);
                  }
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
              ),
              Container(
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
                                  width: getProportionateScreenWidth(50),
                                  height: getProportionateScreenWidth(50),
                                  fit: BoxFit.cover,
                                  imageUrl: adminPhoto),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: getProportionateScreenWidth(20),
                          ),
                          child: Text(
                            adminName,
                            style: TextStyle(
                                fontSize: getProportionalFontSize(14),
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w600,
                                color: Helper.hexToColor("#3D3B3B")),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: SvgPicture.asset(
                        'assets/images/admin_indicator.svg',
                        height: getProportionateScreenWidth(25),
                      ),
                    )
                  ],
                ),
              ),
              list_selected_member.length > 0
                  ? SizedBox(
                      height: getProportionateScreenHeight(75) *
                          list_selected_member.length,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (_, int index) {
                          if (list_selected_member[index].admin) {
                            return Container();
                          }
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
                                        borderRadius:
                                            BorderRadius.circular(80.0),
                                        child: Container(
                                          width:
                                              getProportionateScreenWidth(50),
                                          height:
                                              getProportionateScreenWidth(50),
                                          child: CachedNetworkImage(
                                              width:
                                                  getProportionateScreenWidth(
                                                      50),
                                              height:
                                                  getProportionateScreenWidth(
                                                      50),
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  list_selected_member[index]
                                                      .profile_img),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: getProportionateScreenWidth(20),
                                      ),
                                      child: Text(
                                        list_selected_member[index].name,
                                        style: TextStyle(
                                            fontSize:
                                                getProportionalFontSize(14),
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Helper.hexToColor("#3D3B3B")),
                                      ),
                                    ),
                                  ],
                                ),
                                list_selected_member[index].admin
                                    ? Container(
                                        child: SvgPicture.asset(
                                          'assets/images/admin_indicator.svg',
                                          height:
                                              getProportionateScreenWidth(25),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          );
                        },
                        itemCount: list_selected_member.length,
                      ),
                    )
                  : Container(
                      height: getProportionateScreenHeight(50),
                    ),
              /*list_selected_member.length > 0
                  ? Container(
                      height: getProportionateScreenHeight(50),
                    )
                  : Container(),*/
              /*GestureDetector(
                onTap: () {
                  if (groupNameCon.text.isEmpty) {
                    Helper.showToast("Please enter group name");
                    return;
                  }
                  if (groupTopicCon.text.isEmpty) {
                    Helper.showToast("Please enter group topic");
                    return;
                  }
                  if (list_selected_member.length == 0) {
                    Helper.showToast("Please select member");
                    return;
                  }
                  List<String> other_id = <String>[];
                  list_selected_member.forEach((element) {
                    this
                        .widget
                        .routeArgument!
                        .groupInfo!
                        .group_members
                        .forEach((elementExists) {
                      if (element.id == elementExists.id) {
                        other_id.add(element.id);
                      }
                    });
                  });
                  List<String> removed_id = <String>[];
                  this
                      .widget
                      .routeArgument!
                      .groupInfo!
                      .group_members
                      .forEach((elementExists) {
                    other_id.forEach((element) {
                      if (element != elementExists.id) {
                        removed_id.add(element);
                      }
                    });
                  });

                  removed_id.forEach((element) async {

                    FirebaseFirestore.instance
                        .collection('recentgroups')
                        .doc(element)
                        .collection(element)
                        .doc(this.widget.routeArgument!.groupInfo!.id)
                        .delete();

                    var data = this
                        .widget
                        .routeArgument!
                        .groupInfo!
                        .group_members
                        .firstWhere((elementdata) => element == elementdata.id);
                    final Map<String, dynamic> dataDelete =
                        new Map<String, dynamic>();
                    dataDelete['id'] = data.id;
                    dataDelete['name'] = data.name;
                    dataDelete['image'] = data.profile_img;
                    dataDelete['isAdmin'] = data.admin;

                    await FirebaseFirestore.instance
                        .collection('groups')
                        .doc(this.widget.routeArgument!.groupInfo!.id)
                        .update({
                      "members": FieldValue.arrayRemove([dataDelete])
                    });
                  });

                  _con.sendData.group_id =
                      this.widget.routeArgument!.groupInfo!.id;
                  _con.sendData.group_img = _image;
                  _con.sendData.group_name = groupNameCon.text.toString();
                  _con.sendData.about = groupTopicCon.text.toString();
                  List<String> list_ids = <String>[];
                  list_selected_member.forEach((element) {
                    list_ids.add(element.id);
                  });
                  _con.sendData.members = list_ids.join(",");
                  _con.updateGroup();
                },
                child: Container(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    "assets/images/update_group.svg",
                    height: getProportionateScreenHeight(54),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).padding.bottom + 20,
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}

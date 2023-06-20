import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/GroupController.dart';
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/FriendUser.dart';
import 'package:neuro/Models/route_arguments.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateGroupView extends StatefulWidget {
  TabController? tabController;

  CreateGroupView(controller) {
    tabController = controller;
  }

  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends StateMVC<CreateGroupView> {
  String adminPhoto = "";
  String adminName = "";
  List<FriendUser> list_selected_member = <FriendUser>[];

  var groupNameCon = TextEditingController();
  var groupTopicCon = TextEditingController();

  @override
  void initState() {
    getAdminData();
    super.initState();
    _con.tabController = this.widget.tabController;
    setState(() { });
  }

  getAdminData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    adminName = prefs.getString(Constant.NAME)!;
    adminPhoto = prefs.getString(Constant.PROFILEIMAGE)!;
    setState(() {});
  }

  File? _image;

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

  late GroupController _con;

  _CreateState() : super(GroupController()) {
    _con = controller as GroupController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: SingleChildScrollView(
        child: new Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: getProportionateScreenHeight(34),
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
                    child: _image != null
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(120.0)),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              height: getProportionateScreenWidth(122),
                              width: getProportionateScreenWidth(122),
                            ),
                          )
                        : SvgPicture.asset(
                            'assets/images/add _photo_group.svg',
                            height: getProportionateScreenWidth(122),
                            width: getProportionateScreenWidth(122),
                          ),
                  ),
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
                  "Members".toUpperCase(),
                  style: TextStyle(
                      fontSize: getProportionalFontSize(10),
                      fontFamily: 'poppins',letterSpacing: 1.68,
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
                          new RouteArgument(list_user: list_selected_member,isFromEdit: false));
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
              list_selected_member.length > 0
                  ? Container(
                      height: getProportionateScreenHeight(50),
                    )
                  : Container(),
              GestureDetector(
                onTap: () {
                    if (_image == null) {
                    Helper.showToast("Please select group image");
                    return;
                  }
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
                  _con.sendData.group_img = _image;
                  _con.sendData.group_name = groupNameCon.text.toString();
                  _con.sendData.about = groupTopicCon.text.toString();
                  List<String> list_ids = <String>[];
                  list_selected_member.forEach((element) {
                    list_ids.add(element.id);
                  });
                  _con.sendData.group_id = list_ids.join(",");
                  _con.createGroup(list_selected_member);
                },
                child: Container(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    "assets/images/create_group.svg",
                    height: getProportionateScreenHeight(54),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).padding.bottom + 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

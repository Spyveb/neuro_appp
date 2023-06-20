import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/GroupController.dart';
import 'package:neuro/Helper/FirebaseManager.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/GroupUser.dart';
import 'package:neuro/Models/route_arguments.dart';

class GroupMessageInboxView extends StatefulWidget {
  @override
  _GroupMessageInboxState createState() => _GroupMessageInboxState();
}

class _GroupMessageInboxState extends StateMVC<GroupMessageInboxView> {
  late GroupController _con;

  _GroupMessageInboxState() : super(GroupController()) {
    _con = controller as GroupController;
  }

  List<GroupUser>? temp_list_groups = <GroupUser>[];
  bool isLoading = true;

  void callback() {
    isLoading = true;
    setState(() {});
    FirebaseManager().list_users!.sort((a, b) {
      return (b.time!.compareTo(a.time!));
    });
    temp_list_groups = (FirebaseManager().list_groups!);

    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    FirebaseManager().callback = this.callback;
    callback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: new Container(
        //color: Helper.hexToColor("#E5E5E5"),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (_, int index) {
            return MyGroupView(temp_list_groups![index]);
          },
          itemCount: temp_list_groups!.length,
        ),
      ),
    );
  }
}

class MyGroupView extends StatefulWidget {
  GroupUser data;

  MyGroupView(this.data);

  @override
  _MyGroupState createState() => _MyGroupState(this.data);
}

class _MyGroupState extends StateMVC<MyGroupView> {
  GroupUser data;

  _MyGroupState(this.data);

  int count = 0;
  List<dynamic> images = <dynamic>[];

  @override
  void initState() {
    super.initState();
    // getData();
  }

/*
  getData() async {
    var prefs = await SharedPreferences.getInstance();
    String currentUserId = prefs.getString(Constant.USERID) ?? '';
    if (this.data.list_member.length > 3) {
      for (int i = 0; i < this.data.list_member.length; i++) {
        if (i <= 2) {
          if (this.data.list_member[i].id != currentUserId) {
            images.add(this.data.list_member[i].image);
          }
        } else {
          if (this.data.list_member[i].id != currentUserId) {
            count++;
          }
        }
      }
      images.add("");
    } else {
      this.data.list_member.forEach((element) {
        if (element.id != currentUserId) {
          images.add(element.image);
        }
      });
    }
    setState(() {});
  }
*/

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/FirebaseGroupChat',
            arguments: new RouteArgument(groupUser: this.data));
      },
      child: new Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: getProportionateScreenHeight(2)),
        padding: EdgeInsets.only(
          left: getProportionateScreenWidth(30),
          right: getProportionateScreenWidth(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: getProportionateScreenHeight(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: Text(Helper.dayFormatter(this.data.time),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: getProportionalFontSize(11),
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w500,
                                color: Helper.hexToColor("#ABA7A7"))),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: getProportionateScreenHeight(18),
                      bottom: getProportionateScreenHeight(18)),
                  child: Row(
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
                        width: getProportionateScreenWidth(26),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(this.data.group_name,
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
                            child: Text(this.data.group_topic,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: getProportionalFontSize(11),
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w600,
                                    color: Helper.hexToColor("#A1A1A1"))),
                          ),
                          Container(
                            height: getProportionateScreenHeight(8),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.50,
                            child: Text(
                                this.data.type == "1"
                                    ? "Image"
                                    : this.data.type == "2"
                                        ? "Voice"
                                        : this.data.content,
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
                this.data.count != ""
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: getProportionateScreenHeight(45)),
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
                    : Container()
              ],
            ),
            /*Container(
              margin: EdgeInsets.only(left: getProportionateScreenWidth(110)),
              child: RowSuper(
                innerDistance: -8.0,
                invert: true,
                children: images.map((i) {
                  return i != ""
                      ? Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Helper.hexToColor("#ffffff")),
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
                                color: Helper.hexToColor("#5BAEE2"), width: 2),
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
            ),*/
          ],
        ),
      ),
    );
  }
}

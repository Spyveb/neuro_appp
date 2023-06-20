import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/ProfileController.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/route_arguments.dart';

class ManageScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  ManageScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _ManageState createState() => _ManageState();
}

class _ManageState extends StateMVC<ManageScreen> {
  late ProfileController _con;

  _ManageState() : super(ProfileController(false)) {
    _con = controller as ProfileController;
  }

  @override
  void initState() {
    super.initState();
    _con.isNotification = this.widget.routeArgument!.isNotification!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context, _con.isNotification);
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
        elevation: 0,
        centerTitle: false,
        title: Text(
          "MANAGE ACCOUNT",
          style: TextStyle(
              fontSize: getProportionalFontSize(14),
              fontFamily: 'poppins',
              letterSpacing: 1.68,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(
            top: getProportionateScreenHeight(12),
            left: getProportionateScreenWidth(30),
            right: getProportionateScreenWidth(30)),
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                _deleteAccount();
              },
              child: Container(
                margin: EdgeInsets.only(
                    top: getProportionateScreenHeight(12),
                    bottom: getProportionateScreenHeight(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "DELETE ACCOUNT",
                      style: TextStyle(
                          fontSize: getProportionalFontSize(12),
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w700,
                          color: Helper.hexToColor("#393939")),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Helper.hexToColor("#53AAE0"),
                      size: getProportionateScreenHeight(20),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text("Notifications".toUpperCase(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: getProportionalFontSize(12),
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600,
                          color: Helper.hexToColor("#393939"))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlutterSwitch(
                      width: getProportionateScreenWidth(51),
                      height: getProportionateScreenHeight(31),
                      value: _con.isNotification,
                      onToggle: (val) async {
                        setState(() {
                          _con.isNotification = val;
                          this.widget.routeArgument!.isNotification = val;
                          _con.sendNotificationData.notification =
                              val ? "1" : "0";
                          _con.updateNotifcationStatus();
                        });
                      },
                      activeColor: Helper.hexToColor("#53AAE0"),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _deleteAccount() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account',
              style: TextStyle(
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w400,
                  color: Helper.hexToColor("#000000"))),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'Do you want to delete account from app?',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w600,
                      color: Helper.hexToColor("#000000")),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w700,
                      color: Helper.hexToColor("#5BAEE2"))),
              onPressed: () async {
                _con.deleteaccount();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('No',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w700,
                      color: Helper.hexToColor("#000000"))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

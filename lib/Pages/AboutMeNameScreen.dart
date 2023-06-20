import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Register.dart';
import 'package:neuro/Models/route_arguments.dart';

class AboutMeNameScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  AboutMeNameScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _AboutMeNameState createState() => _AboutMeNameState();
}

class _AboutMeNameState extends StateMVC<AboutMeNameScreen>
    with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));
    if(this.widget.routeArgument!.register != null){
      fullNameCon.text = this.widget.routeArgument!.register!.name;
      setState(() { });
    }
  }

  var fullNameCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Scaffold(
      resizeToAvoidBottomInset: false,
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
        elevation: 0,
        centerTitle: false,
        title: Text(
          "ABOUT ME",
          style: TextStyle(
              fontSize: getProportionalFontSize(14),
              fontFamily: 'poppins',
              letterSpacing: 1.68,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
      body: FooterLayout(
          child: Container(
            margin: EdgeInsets.only(
                top: getProportionateScreenHeight(174),
                left: getProportionateScreenWidth(30),
                right: getProportionateScreenWidth(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text("Full Name",
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
                    controller: fullNameCon,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      border: new UnderlineInputBorder(
                          borderSide: new BorderSide(
                              width: 1, color: Helper.hexToColor("#E4E7F1"))),
                      focusedBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(
                              width: 1, color: Helper.hexToColor("#E4E7F1"))),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(
                              width: 1, color: Helper.hexToColor("#E4E7F1"))),
                      hintText: "eg: John Doe",
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
          footer: KeyboardAttachableFooter(
              fullNameCon, this.widget.routeArgument!.register!)),
    );
  }
}

class KeyboardAttachableFooter extends StatelessWidget {
  var firstnameCon;

  Register sendData;

  KeyboardAttachableFooter(this.firstnameCon, this.sendData);

  @override
  Widget build(BuildContext context) => KeyboardAttachable(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
            onTap: () {
              if (firstnameCon.text == "") {
                Helper.showToast("Please enter first name");
                return;
              }
              this.sendData.name = firstnameCon.text.toString();
              Navigator.pushNamed(context, '/AboutMeProfilePicture',
                  arguments: new RouteArgument(register: this.sendData));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: getProportionateScreenHeight(80),
              child: Image.asset(
                "assets/images/bottom_next.png",
                fit: BoxFit.cover,
              ),
            )),
      );
}

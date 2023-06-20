import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Register.dart';
import 'package:neuro/Models/route_arguments.dart';

class AboutMeEmailScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  AboutMeEmailScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _AboutEmailState createState() => _AboutEmailState();
}

class _AboutEmailState extends StateMVC<AboutMeEmailScreen> {
  bool isEditable = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));
    if(this.widget.routeArgument!.register != null){
      emailCon.text = this.widget.routeArgument!.register!.email;
      if(this.widget.routeArgument!.register!.email.isNotEmpty){
        isEditable = true;
      }
      setState(() { });
    }
  }

  var emailCon = TextEditingController();

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
              letterSpacing: 1.68,
              fontSize: getProportionalFontSize(14),
              fontFamily: 'poppins',
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
                  child: Text("Email",
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
                    readOnly: isEditable,
                    controller: emailCon,
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
                      hintText: "eg: john@gmail.com",
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
              emailCon, this.widget.routeArgument!.register!)),
    );
  }

}

class KeyboardAttachableFooter extends StatelessWidget {
  var emailCon;

  Register sendData;

  KeyboardAttachableFooter(this.emailCon, this.sendData);

  @override
  Widget build(BuildContext context) => KeyboardAttachable(
    backgroundColor: Colors.transparent,
    child: GestureDetector(
        onTap: () {
          if (emailCon.text == "") {
            Helper.showToast("Please enter email");
            return;
          }
          this.sendData.email = emailCon.text.toString();
          Navigator.pushNamed(context, '/AboutMeName',
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


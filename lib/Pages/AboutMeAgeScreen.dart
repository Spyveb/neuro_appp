import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Register.dart';
import 'package:neuro/Models/route_arguments.dart';

class AboutMeAgeScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  AboutMeAgeScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _AboutMeAgeState createState() => _AboutMeAgeState();
}

class _AboutMeAgeState extends StateMVC<AboutMeAgeScreen> {
  var dobCon = TextEditingController();
  var selectDate;

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
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: getProportionateScreenHeight(174),
                    left: getProportionateScreenWidth(30),
                    right: getProportionateScreenWidth(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("Date Of Birth",
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
                        onTap: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now()
                                  .subtract(new Duration(days: 36500)),
                              maxTime: DateTime.now().subtract(new Duration(days: 5844)),
                              theme: DatePickerTheme(
                                  headerColor: Helper.hexToColor("#5BAEE2"),
                                  backgroundColor: Colors.white,
                                  itemStyle: TextStyle(
                                      color: Helper.hexToColor("#5BAEE2"),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppins',
                                      fontSize: getProportionalFontSize(18)),
                                  cancelStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'poppins',
                                  ),
                                  doneStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'poppins',
                                  )), onChanged: (date) {
                            print('change $date in time zone ' +
                                date.timeZoneOffset.inHours.toString());
                          }, onConfirm: (date) {
                            print('confirm $date');
                            selectDate = date;
                            final DateFormat formatter =
                                DateFormat('dd-MM-yyyy');
                            dobCon.text = formatter.format(date);
                            setState(() {});
                          },
                              currentTime: selectDate != null
                                  ? selectDate
                                  : DateTime.now(),
                              locale: LocaleType.en);
                        },
                        controller: dobCon,
                        readOnly: true,
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
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
                          hintText: "eg: 20-07-1999",
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
            ],
          ),
        ),
        footer: KeyboardAttachableFooter(
            dobCon, this.widget.routeArgument!.register),
      ),
    );
  }
}

class KeyboardAttachableFooter extends StatelessWidget {
  var dobCon;

  Register? sendData;

  KeyboardAttachableFooter(this.dobCon, this.sendData);

  @override
  Widget build(BuildContext context) => KeyboardAttachable(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            if (dobCon.text.toString().isEmpty) {
              Helper.showToast("Please enter age");
              return;
            }
            this.sendData!.dob = dobCon.text.toString();
            Navigator.pushNamed(context, '/AboutMeAbout',
                arguments: new RouteArgument(register: this.sendData));
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: getProportionateScreenHeight(80),
            child: Image.asset(
              "assets/images/bottom_next.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
}

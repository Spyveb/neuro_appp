import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/PrimeController.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/PaymentService.dart';
import 'package:neuro/Helper/size_config.dart';

class PremiumPlanScreen extends StatefulWidget {
  @override
  _PremiumState createState() => _PremiumState();
}

class _PremiumState extends StateMVC<PremiumPlanScreen> {
  late PrimeController _con;

  _PremiumState() : super(PrimeController()) {
    _con = controller as PrimeController;
  }

  PaymentService _paymentService = new PaymentService();
  String symbolprice = "";

  @override
  void initState() {
    super.initState();
    //_paymentService.initConnection();
    _paymentService.addToProStatusChangedListeners(_callbackPro);
    _paymentService.addToErrorListeners(_callbackProError);
    _paymentService.products.then((value) => {
          print(value[0].toString()),
          symbolprice = value[0].currency! +
              " " +
              value[0].price!,
          setState(() {}),
        });
  }

  _callbackPro() {
    if(_con.loader.mounted){
      _con.loader.remove();
    }
    Helper.showToast("Plan successfully upgraded");
    _con.sendData.status = true;
    _con.sendData.subdevice = _paymentService.subdevice;
    _con.sendData.premiumtoken = _paymentService.premiumtoken;
    _con.premiumStatus();
  }

  _callbackProError(String data) {
    if(_con.loader.mounted){
      _con.loader.remove();
    }
    Helper.showToast(data);
  }

  @override
  void dispose() {
    //_paymentService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Scaffold(
      key: _con.scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      /*appBar: AppBar(
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
      ),*/
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: getProportionateScreenHeightMain(41),
                  ),
                  Container(
                    width: getProportionateScreenWidth(130),
                    height: getProportionateScreenHeight(40),
                    child: Image.asset('assets/images/premium.png',
                        width: getProportionateScreenWidth(130),
                        height: getProportionateScreenHeight(40),
                        fit: BoxFit.contain),
                  ),
                  Container(
                    height: getProportionateScreenHeight(43),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: getProportionateScreenWidth(125),
                    height: getProportionateScreenWidth(116),
                    child: Image.asset("assets/images/security_icon.png"),
                  ),
                  Container(
                    height: getProportionateScreenHeight(56),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: getProportionateScreenWidth(87),
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                  width: getProportionateScreenWidth(24),
                                  height: getProportionateScreenWidth(24),
                                  child: Image.asset(
                                    "assets/images/infinity_icon.png",
                                    width: getProportionateScreenWidth(24),
                                    height: getProportionateScreenWidth(24),
                                  )),
                              Container(
                                width: getProportionateScreenWidth(25),
                              ),
                              Container(
                                child: Text("Unlimited swipes a day",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: getProportionalFontSize(14),
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.w600,
                                        color: Helper.hexToColor("#393939"))),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: getProportionateScreenHeight(19),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Container(
                                  width: getProportionateScreenWidth(24),
                                  height: getProportionateScreenWidth(24),
                                  child: Image.asset(
                                    "assets/images/user_icon.png",
                                    width: getProportionateScreenWidth(24),
                                    height: getProportionateScreenWidth(24),
                                  )),
                              Container(
                                width: getProportionateScreenWidth(25),
                              ),
                              Container(
                                child: Text("Group chat access",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: getProportionalFontSize(14),
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.w600,
                                        color: Helper.hexToColor("#393939"))),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: getProportionateScreenHeight(19),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Container(
                                  width: getProportionateScreenWidth(24),
                                  height: getProportionateScreenWidth(24),
                                  child: Image.asset(
                                    "assets/images/time_icon.png",
                                    width: getProportionateScreenWidth(24),
                                    height: getProportionateScreenWidth(24),
                                  )),
                              Container(
                                width: getProportionateScreenWidth(25),
                              ),
                              Container(
                                child: Text("10 free nudges",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: getProportionalFontSize(14),
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.w600,
                                        color: Helper.hexToColor("#393939"))),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: getProportionateScreenHeight(19),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Container(
                                  width: getProportionateScreenWidth(24),
                                  height: getProportionateScreenWidth(24),
                                  child: Image.asset(
                                    "assets/images/new_secure.png",
                                    width: getProportionateScreenWidth(24),
                                    height: getProportionateScreenWidth(24),
                                  )),
                              Container(
                                width: getProportionateScreenWidth(25),
                              ),
                              Container(
                                child: Text("All 3 modes unlocked",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: getProportionalFontSize(14),
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.w600,
                                        color: Helper.hexToColor("#393939"))),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: getProportionateScreenHeight(27),
                  ),
                  Container(
                    child: Text(symbolprice.toUpperCase(),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: getProportionalFontSize(48),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w600,
                            color: Helper.hexToColor("#393939"))),
                  ),
                  Container(
                    child: Text("per month".toUpperCase(),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: getProportionalFontSize(14),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w600,
                            color: Helper.hexToColor("#393939"))),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 25,top: 20,right: 25,bottom: 20),
                      child: SvgPicture.asset(
                        "assets/images/left_arrow.svg",
                      ),
                    ),
                  ),
                )
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(_con.scaffoldKey.currentContext!).unfocus();
                    Overlay.of(_con.scaffoldKey.currentContext!)!.insert(_con.loader);
                    _paymentService.products.then((value) => {
                      print(value[0].toString()),
                      _paymentService.buyProduct(value[0]),
                    });
                    /*_con.sendData.status = true;
                      _con.premiumStatus();*/
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: getProportionateScreenHeight(10),
                        left: getProportionateScreenWidth(30),
                        right: getProportionateScreenWidth(30)),
                    child: Image.asset(
                      "assets/images/upgrade_icon.png",
                      height: getProportionateScreenHeight(60),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

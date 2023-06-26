import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/NudgeController.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';

class BuyNudegeScreen extends StatefulWidget {
  @override
  _BuyNudegeState createState() => _BuyNudegeState();
}

class _BuyNudegeState extends StateMVC<BuyNudegeScreen> {
  late NudgeController _con;

  _BuyNudegeState() : super(NudgeController()) {
    _con = controller as NudgeController;
  }

  late StreamSubscription _purchaseUpdatedSubscription;
  late StreamSubscription _purchaseErrorSubscription;
  late StreamSubscription _conectionSubscription;
  final List<String> _productLists = Platform.isAndroid
      ? [
          'android.test.purchased',
        ]
      : ['com.nudge.five'];

  String _platformVersion = 'Unknown';

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   platformVersion = (await FlutterInappPurchase.instance.platformVersion)!;
    // } on PlatformException {
    //   platformVersion = 'Failed to get platform version.';
    // }

    // prepare
    var result = await FlutterInappPurchase.instance.initialize();
    print('result: $result');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // setState(() {
    //   _platformVersion = platformVersion;
    // });

    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAll();
      print('consumeAllItems: $msg');
    } catch (err) {
      print('consumeAllItems error: $err');
    }

    _conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      print('purchase-updated123: $productItem');
      _con.loader.remove();
      _con.buyNudge();
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      _con.loader.remove();
      print('purchase-error: $purchaseError');
      Helper.showToast(purchaseError!.message!);
    });

    _getProduct();
  }

  void _requestPurchase(IAPItem item) {
    FlutterInappPurchase.instance.requestPurchase(item.productId!);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<StreamSubscription>(
        '_purchaseErrorSubscription', _purchaseErrorSubscription));
  }

  List<IAPItem> _items = [];
  var symbolprice = "";

  Future _getProduct() async {
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getProducts(_productLists);
    for (var item in items) {
      print('${item.toString()}');
      this._items.add(item);
    }

    setState(() {
      this._items = items;
    });
    _items.forEach((element) {
      if (element.productId == "com.nudge.five") {
        symbolprice = element.currency! + " " + element.price!;
      } else if (element.productId == "android.test.purchased") {
        symbolprice = element.currency! + " " + element.price!;
      }
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    if (_conectionSubscription != null) {
      _conectionSubscription.cancel();
      //_conectionSubscription = null;
    }
    _purchaseUpdatedSubscription.cancel();
    _purchaseErrorSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Scaffold(
      key: _con.scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      /*appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .backgroundColor,
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
                    height: getProportionateScreenHeight(50),
                  ),
                  Container(
                    width: getProportionateScreenWidth(130),
                    height: getProportionateScreenHeight(40),
                    child: Image.asset('assets/images/buy_nudgesfont.png',
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
                    child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                              colors: [
                                Helper.hexToColor("#FF4350"),
                                Helper.hexToColor("#F5347F"),
                                Helper.hexToColor("#BF00FF")
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [
                                .2,
                                .5,
                                2,
                              ]).createShader(bounds);
                        },
                        child: Image.asset("assets/images/time_icon.png")),
                  ),
                  Container(
                    height: getProportionateScreenHeight(52),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: getProportionateScreenWidth(30),
                        right: getProportionateScreenWidth(30)),
                    child: Text(
                        "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur in culpa qui officia deserunt mollit anim id est laborum.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: getProportionalFontSize(14),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: Helper.hexToColor("#393939"))),
                  ),
                  Container(
                    height: getProportionateScreenHeight(60),
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
                    child: Text("5 nudges".toUpperCase(),
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
                        padding: EdgeInsets.all(20),
                        child: SvgPicture.asset(
                          "assets/images/left_arrow.svg",
                        ),
                      ),
                    ),
                  )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(_con.scaffoldKey.currentContext!).unfocus();
                      Overlay.of(_con.scaffoldKey.currentContext!)!
                          .insert(_con.loader);
                      if (_items.length > 0) {
                        /*FocusScope.of(_con.scaffoldKey.currentContext!).unfocus();
                        Overlay.of(_con.scaffoldKey.currentContext!)!.insert(_con.loader);*/
                        //_requestPurchase(_items[0]);
                        _items.forEach((element) {
                          if (element.productId == "com.nudge.five") {
                            _requestPurchase(element);
                          } else if (element.productId ==
                              "android.test.purchased") {
                            _requestPurchase(element);
                          }
                        });
                      } else {
                        _con.loader.remove();
                        Helper.showToast("Something went wrong");
                      }
                      //_con.buyNudge();
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: getProportionateScreenHeight(10),
                          left: getProportionateScreenWidth(30),
                          right: getProportionateScreenWidth(30)),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            "assets/images/button_back.png",
                            height: getProportionateScreenHeight(60),
                          ),
                          Text(
                            "5 Nudges for ${symbolprice}",
                            style: TextStyle(
                                fontSize: getProportionalFontSize(14),
                                fontFamily: 'poppins',
                                letterSpacing: 1.68,
                                fontWeight: FontWeight.w600,
                                color: Helper.hexToColor("#ffffff")),
                          )
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

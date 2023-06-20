import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Models/Premium.dart';
import 'package:neuro/Repository/PremiumRepository.dart' as repoPremium;

class PrimeController extends ControllerMVC {
  late GlobalKey<ScaffoldState> scaffoldKey;
  late OverlayEntry loader;
  Premium sendData = new Premium();

  PrimeController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    loader = Helper.overlayLoader(this.scaffoldKey.currentContext);
  }

  void premiumStatus() async {
    // FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    ///Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoPremium
                  .premiumStatusChange(sendData)
                  .then((value) => {
                       // loader.remove(),
                        setState(() {}),
                        Navigator.pop(this.scaffoldKey.currentContext!, "1"),
                      })
                  .catchError((e) {
                print(e);
              }).whenComplete(() {
                try {
                 // Helper.hideLoader(loader);
                } catch (e) {}
              })
            }
          else
            {
             // loader.remove(),
              Helper.showToast("No Internet Connection"),
            }
        });
  }
}

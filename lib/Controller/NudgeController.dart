import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Repository/NudgeRepository.dart' as repoNudege;

class NudgeController extends ControllerMVC {
  late GlobalKey<ScaffoldState> scaffoldKey;
  late OverlayEntry loader;

  NudgeController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    loader = Helper.overlayLoader(this.scaffoldKey.currentContext);
  }

  void buyNudge() async {
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoNudege
                  .buyNudge()
                  .then((value) => {
                        if (value.isDone)
                          {
                            Helper.showToast(value.message),
                            Navigator.pop(
                                this.scaffoldKey.currentContext!, "1"),
                          }
                        else
                          {
                            Helper.showToast(value.message),
                          },
                        loader.remove(),
                      })
                  .catchError((e) {
                print(e);
              }).whenComplete(() {
                try {
                  Helper.hideLoader(loader);
                } catch (e) {}
              })
            }
          else
            {
              loader.remove(),
              Helper.showToast("No Internet Connection"),
            }
        });
  }
}

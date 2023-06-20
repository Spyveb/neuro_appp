import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Models/SentRequest.dart';
import 'package:neuro/Repository/SentRequestRepository.dart' as repoSent;

class SentRequestController extends ControllerMVC {
  late GlobalKey<ScaffoldState> scaffoldKey;
  late OverlayEntry loader;
  List<SentRequest> list_data = <SentRequest>[];
  bool isLoading = true;
  String userNudgeCount = "";
  SentRequest sendNudge = new SentRequest();

  SentRequestController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    loader = Helper.overlayLoader(this.scaffoldKey.currentContext);
  }

  void getSentRequestList(bool isShow) async {
    isLoading = true;
    setState(() {});
    /*if (!isShow) {
      FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
      Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    }*/
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoSent
                  .getSentRequestList()
                  .then((value) => {
                        list_data.clear(),
                        list_data.addAll(value.list_request),
                        userNudgeCount = value.user_budge,
                        isLoading = false,
                        setState(() {}),
                        //loader.remove(),
                      })
                  .catchError((e) {
                print(e);
                isLoading = false;
                setState(() {});
                Helper.showToast("Something went wrong");
              }).whenComplete(() {
                //Helper.hideLoader(loader);
              })
            }
          else
            {
              isLoading = false,
              setState(() {}),
              //loader.remove(),
              Helper.showToast("No Internet Connection"),
            }
        });
  }

  void sendNudgeRequest() async {
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoSent
                  .sendNudge(this.sendNudge)
                  .then((value) => {
                        //loader.remove(),
                      })
                  .catchError((e) {})
                  .whenComplete(() async {
                isLoading = true;
                list_data.clear();
                setState(() {});
                Future.delayed(const Duration(milliseconds: 300), () {
                  getSentRequestList(true);
                });
              })
            }
          else
            {
              isLoading = false,
              setState(() {}),
              loader.remove(),
              Helper.showToast("No Internet Connection"),
            }
        });
  }
}

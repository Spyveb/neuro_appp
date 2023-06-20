import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Models/Matches.dart';
import 'package:neuro/Models/NeuroRequest.dart';
import 'package:neuro/Repository/MatcheRepository.dart' as repoMatche;

class MatcheController extends ControllerMVC {
  late GlobalKey<ScaffoldState> scaffoldKey;
  late OverlayEntry loader;
  List<Matches> list_data = <Matches>[];
  bool isLoading = true;

  MatcheController(bool isCall) {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    loader = Helper.overlayLoader(this.scaffoldKey.currentContext);
    if (isCall) {
      Future.delayed(const Duration(milliseconds: 300), () {
        getMatchList();
      });
    }
  }

  void refreshList() {
    isLoading = true;
    list_data.clear();
    setState(() {});
    getMatchList();
  }

  void getMatchList() async {
    isLoading = true;
    setState(() {});
    /*FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);*/
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoMatche
                  .getMatches()
                  .then((value) => {
                        list_data.clear(),
                        list_data.addAll(value),
                        isLoading = false,
                        setState(() {}),
                       // loader.remove(),
                      })
                  .catchError((e) {
                print(e);
                isLoading = false;
                setState(() {});
                Helper.showToast("Something went wrong");
              }).whenComplete(() {
                isLoading = false;
                setState(() {});
                //Helper.hideLoader(loader);
              })
            }
          else
            {
             // loader.remove(),
              Helper.showToast("No Internet Connection"),
            }
        });
  }

  void removeMatches(NeuroRequest sendData) async {
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoMatche
                  .removeMatches(sendData)
                  .then((value) => {})
                  .catchError((e) {
                print(e);
              }).whenComplete(() {})
            }
          else
            {
              loader.remove(),
              Helper.showToast("No Internet Connection"),
            }
        });
  }

  void sendNotifcation(Map data) async {
    Helper.isConnect().then((value) => {
      if (value)
        {repoMatche.sendNotification(data)}
      else
        {
          Helper.showToast("No internet connection"),
        }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Models/Matches.dart';
import 'package:neuro/Models/NeuroRequest.dart';
import 'package:neuro/Models/route_arguments.dart';
import 'package:neuro/Repository/NeuroRequestRepository.dart' as repoNeuro;

class NeuroRequestController extends ControllerMVC {
  late GlobalKey<ScaffoldState> scaffoldKey;
  late OverlayEntry loader;
  List<NeuroRequest> list_data = <NeuroRequest>[];
  bool isLoading = true;
  NeuroRequest sendData = new NeuroRequest();

  NeuroRequestController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    loader = Helper.overlayLoader(this.scaffoldKey.currentContext);
  }

  void getNeuroRequestList() async {
    isLoading = true;
    setState(() {});
    /*FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);*/
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoNeuro
                  .getNeuroRequestList()
                  .then((value) => {
                        list_data.clear(),
                        list_data.addAll(value),
                        isLoading = false,
                        setState(() {}),
                        //loader.remove(),
                      })
                  .catchError((e) {
                print(e);
                isLoading = false;
                setState(() {});
              }).whenComplete(() {
                //Helper.hideLoader(loader);
              })
            }
          else
            {
              isLoading = false,
              setState(() {}),
             // loader.remove(),
              Helper.showToast("No Internet Connection"),
            }
        });
  }

  void acceptReject(NeuroRequest sendData, NeuroRequest removeIndex,
      [Matches? sendDataMatch]) async {
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoNeuro
                  .acceptrejectRequest(sendData)
                  .then((value) => {
                        loader.remove(),
                        list_data.remove(removeIndex),
                        //list_data.clear(),
                        //isLoading = true,
                        setState(() {}),
                      })
                  .catchError((e) {
                print(e);
              }).whenComplete(() {
                try {
                  Helper.hideLoader(loader);
                } catch (e) {}
                /*Future.delayed(const Duration(milliseconds: 300), () {
                  getNeuroRequestList();
                });*/
                if (sendDataMatch != null) {
                  Navigator.pushNamed(
                      this.scaffoldKey.currentContext!, '/Match',
                      arguments: new RouteArgument(matches: sendDataMatch));
                }
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

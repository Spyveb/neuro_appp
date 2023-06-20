import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Models/FriendUser.dart';
import 'package:neuro/Models/Group.dart';
import 'package:neuro/Repository/UserSelectionRepository.dart' as repoSelection;

class UserSelectionController extends ControllerMVC {
  late GlobalKey<ScaffoldState> scaffoldKey;
  late OverlayEntry loader;
  List<FriendUser> list_data = <FriendUser>[];
  List<FriendUser> main_list_data = <FriendUser>[];
  bool isLoading = true;
  FriendUser sendData = new FriendUser();
  Group addRemoveSendData = new Group();

  UserSelectionController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    loader = Helper.overlayLoader(this.scaffoldKey.currentContext);
  }

  void getFriendList(List<FriendUser>? list_user) async {
    isLoading = true;
    setState(() {});
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoSelection
                  .getFriendList(sendData)
                  .then((value) => {
                        list_data.clear(),
                        list_data.addAll(value),
                        list_data.forEach((element) {
                          if (list_user != null) {
                            list_user.forEach((elementData) {
                              if (elementData.id.toUpperCase() ==
                                  element.id.toUpperCase()) {
                                element.isSelected = true;
                              }
                            });
                          }
                        }),
                        main_list_data.clear(),
                        main_list_data.addAll(value),
                        isLoading = false,
                        setState(() {}),
                        loader.remove(),
                      })
                  .catchError((e) {
                print(e);
                isLoading = false;
                setState(() {});
                Helper.showToast("Something went wrong");
              }).whenComplete(() {
                isLoading = false;
                setState(() {});
                Helper.hideLoader(loader);
              })
            }
          else
            {
              loader.remove(),
              Helper.showToast("No Internet Connection"),
            }
        });
  }

  void addRemoveUser() async {
    isLoading = true;
    setState(() {});
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoSelection
                  .addRemoveGroup(addRemoveSendData)
                  .then((value) => {
                        loader.remove(),
                      })
                  .catchError((e) {
                print(e);
                Helper.showToast("Something went wrong");
              }).whenComplete(() {
                Helper.hideLoader(loader);
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

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Models/CreateGroup.dart';
import 'package:neuro/Models/FriendUser.dart';
import 'package:neuro/Models/Group.dart';
import 'package:neuro/Models/GroupRequest.dart';
import 'package:neuro/Models/NeuroRequest.dart';
import 'package:neuro/Repository/GroupRepository.dart' as repoGroup;

class GroupController extends ControllerMVC {
  late GlobalKey<ScaffoldState> scaffoldKey;
  late OverlayEntry loader;
  CreateGroup sendData = new CreateGroup();
  List<GroupRequest> list_data = <GroupRequest>[];
  List<Group> list_group_data = <Group>[];
  bool isLoading = true;
  TabController? tabController;
  Group sendDataGroupInfo = Group();
  Group data = Group();

  GroupController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    loader = Helper.overlayLoader(this.scaffoldKey.currentContext);
  }

  void createGroup(List<FriendUser> list_selected_member) async {
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoGroup
                  .createGroup(this.sendData,list_selected_member)
                  .then((value) => {
                        loader.remove(),
                        if (value.isDone)
                          {
                            this.tabController!.animateTo(0),
                            Helper.showToast(value.error),
                          }
                        else
                          {
                            Helper.showToast(value.error),
                          },
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

  void updateGroup() async {
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoGroup
                  .updateGroup(this.sendData)
                  .then((value) => {
                        loader.remove(),
                        if (value.isDone)
                          {
                            Navigator.pop(this.scaffoldKey.currentContext!,"1"),
                            Helper.showToast(value.error),
                          }
                        else
                          {
                            Helper.showToast(value.error),
                          },
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

  void getGroupRequestList() async {
    isLoading = true;
    setState(() {});
    /*FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);*/
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoGroup
                  .getGroupListRequest()
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

  void acceptReject(
    NeuroRequest sendData,
    int removeIndex,
  ) async {
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoGroup
                  .acceptrejectRequest(sendData)
                  .then((value) => {
                        loader.remove(),
                        list_data.removeAt(removeIndex),
                        setState(() {}),
                      })
                  .catchError((e) {
                print(e);
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

  void getGroupList() async {
    isLoading = true;
    setState(() {});
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoGroup
                  .getGroupList()
                  .then((value) => {
                        list_group_data.clear(),
                        list_group_data.addAll(value),
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
                Helper.hideLoader(loader);
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

  void getGroupInfo() async {
    isLoading = true;
    setState(() {});
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoGroup
                  .getGroupInfo(this.sendDataGroupInfo)
                  .then((value) => {
                        data = value,
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
                Helper.hideLoader(loader);
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

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/Feed.dart';
import 'package:neuro/Models/Profile.dart';
import 'package:neuro/Models/Report.dart';
import 'package:neuro/Repository/FeedsRepository.dart' as repoFeed;
import 'package:neuro/Repository/ProfileRepository.dart' as repoProfile;
import 'package:neuro/Repository/ReportRepository.dart' as repoReport;

class FeedController extends ControllerMVC {
  late GlobalKey<ScaffoldState> scaffoldKey;
  late OverlayEntry loader;
  List<Feed> list_feeds = <Feed>[];
  Feed sendData = new Feed();
  Profile data = new Profile();
  Profile sendDataProfile = new Profile();
  Feed sendSwipe = new Feed();
  bool isLoading = true;
  bool isNext = true;

  FeedController(bool isFeed) {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    loader = Helper.overlayLoader(this.scaffoldKey.currentContext);
    if (isFeed) {
      Future.delayed(const Duration(milliseconds: 300), () {
        getFeeds();
      });
    }
  }

  double widthCustomName = 0.0;

  void getuserProfile() async {
    Size textSize;
    //FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    //Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoProfile
                  .getProfile(sendDataProfile)
                  .then((value) => {
                        data = value,
                        textSize = Helper.textSize(
                            "${value.name}, ${value.birthdate}",
                            TextStyle(
                                fontSize: getProportionalFontSize(30),
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        if (textSize.width >
                            (MediaQuery.of(this.scaffoldKey.currentContext!)
                                    .size
                                    .width *
                                0.60))
                          {
                            widthCustomName =
                                MediaQuery.of(this.scaffoldKey.currentContext!)
                                        .size
                                        .width *
                                    0.55,
                          }
                        else
                          {
                            widthCustomName = textSize.width,
                          },
                        setState(() {}),
                        //loader.remove(),
                      })
                  .catchError((e) {
                print(e);
                Helper.showToast("Something went wrong");
              }).whenComplete(() {
                //Helper.hideLoader(loader);
              })
            }
          else
            {
              //loader.remove(),
              Helper.showToast("No Internet Connection"),
            }
        });
  }

  void getFeeds() async {
    isLoading = true;
    setState(() {});
    var result;
    // FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    // Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoFeed
                  .getFeeds(this.sendData)
                  .then((value) async => {
                        list_feeds.clear(),
                        list_feeds.addAll(value.list_feeds),
                        isNext = value.isNext,
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
                // Helper.hideLoader(loader);
              })
            }
          else
            {
              // loader.remove(),
              isLoading = true,
              setState(() {}),
              Helper.showToast("No Internet Connection"),
            }
        });
  }

  void feedSwipe(bool isLoad) async {
    if (isLoad) {
      FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
      Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    }
    Object? result;
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoFeed
                  .feedSwipe(this.sendSwipe)
                  .then((value) async => {
                        isNext = value,
                        setState(() {}),
                        if (isLoad)
                          {
                            loader.remove(),
                          },
                        if (!value)
                          {
                            result = await Navigator.pushNamed(
                                this.scaffoldKey.currentContext!,
                                '/PremiumPlan'),
                            if (result != null)
                              {
                                getFeeds(),
                              }
                          }
                      })
                  .catchError((e) {
                if (isLoad) {
                  loader.remove();
                }
                print(e);
                Helper.showToast("Something went wrong");
              }).whenComplete(() {
                if (isLoad) {
                  Helper.hideLoader(loader);
                }
              })
            }
          else
            {
              Helper.showToast("No Internet Connection"),
            }
        });
  }

  void reportUser(Report sendData) async {
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoReport
                  .reportUser(sendData)
                  .then((value) => {
                        Helper.showToast("Report Successfully"),
                        loader.remove(),
                      })
                  .catchError((e) {
                loader.remove();
                print(e);
                Helper.showToast("Something went wrong");
              }).whenComplete(() {
                Helper.hideLoader(loader);
              })
            }
          else
            {
              Helper.showToast("No Internet Connection"),
            }
        });
  }
}

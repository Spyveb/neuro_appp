import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:neuro/Helper/NotificationView.dart';
import 'package:neuro/Models/FirebaseUser.dart';
import 'package:neuro/Models/GroupUser.dart';
import 'package:neuro/Models/MessageUser.dart';
import 'package:neuro/Models/route_arguments.dart';
import 'package:neuro/Pages/FeedsDetailsScreen.dart';
import 'package:neuro/Pages/FirebaseChatScreen.dart';
import 'package:neuro/Pages/FirebaseGroupChatScreen.dart';
import 'package:overlay_support/overlay_support.dart';

import '../main.dart';
import 'GlobalVariable.dart';

class FirebaseMessages extends Object {
  late Map<String, dynamic> pendingNotification;
  late FirebaseMessaging _firebaseMessaging;
  String _fcmToken = "";

  String get fcmToken => _fcmToken;

  bool _isAppStarted = false;

  factory FirebaseMessages() {
    return _singleton;
  }

  static final FirebaseMessages _singleton = new FirebaseMessages._internal();

  FirebaseMessages._internal() {
    print("======== Firebase Messaging instance created ========");
    _firebaseMessaging = FirebaseMessaging.instance;
    firebaseCloudMessagingListeners();
  }

  Future<String?> getFCMToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null && token.isNotEmpty) {
        print("========= FCM Token :: $token =======");
        _fcmToken = token;
      }
    } catch (e) {
      print("Error :: ${e.toString()}");
      return null;
    }
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) {
      iOSPermission();
    }
    FirebaseMessaging.onMessage.listen((event) {
      Future.delayed(
          Duration(seconds: 1),
          () => this.displayNotificationView(
              payload: event.data, remoteNotification: event.notification!));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      FirebaseMessages.notificationOperation(payload: event.data);
    });
  }

  void iOSPermission() {
    _firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);
  }

  void displayNotificationView(
      {required Map<String, dynamic> payload,
      required RemoteNotification remoteNotification}) {
    String title = "Neuro";
    String body = "";
    print(payload.toString());
    print("Display notification view ");

    body = payload['title'];
    if (payload['status'] == "chat" || payload['status'] == "groupchat") {
      return;
    }

    showOverlayNotification((BuildContext _cont) {
      return NotificationView(
          title: title,
          subTitle: body,
          onTap: (isAllow) {
            OverlaySupportEntry.of(_cont)!.dismiss();
            if (isAllow) {
              FirebaseMessages.notificationOperation(payload: payload);
            }
          });
    }, duration: Duration(milliseconds: 5000));
  }

  static void notificationOperation({required Map<String, dynamic> payload}) {
    print(" Notification On tap Detected " + payload.toString());
    if (payload['status'] == "request") {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(GlobalVariable.navState.currentContext!)
            .push(MaterialPageRoute(
                builder: (context) => FeedsDetailsScreen(
                      routeArgument: new RouteArgument(
                          isMatches: false,
                          FeedId: payload["id"],
                          isNormal: false),
                    )));
      });
    } else if (payload['status'] == "accept") {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(GlobalVariable.navState.currentContext!)
            .push(MaterialPageRoute(
                builder: (context) => FeedsDetailsScreen(
                      routeArgument: new RouteArgument(
                          isMatches: true,
                          FeedId: payload["id"],
                          isNormal: false),
                    )));
      });
    } else if (payload['status'] == "chat") {
      Map userObject = json.decode(payload['userObject']);
      MessageUser userChat = new MessageUser(userObject['id'].toString(),
          userObject['photoUrl'].toString(), userObject['nickname'].toString());
      if(isInChat){
        if(chatuserId == userObject['id'].toString()){
          return;
        }
      }
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(GlobalVariable.navState.currentContext!)
            .push(MaterialPageRoute(
                builder: (context) => FirebaseChatScreen(
                      routeArgument: new RouteArgument(userChat: userChat),
                    )));
      });
    } else if (payload['status'] == "groupchat") {
      Map userObject = json.decode(payload['userObject']);
      GroupUser userChat = new GroupUser();
      userChat.id = userObject["id"];
      userChat.group_name = userObject["group_name"];
      userChat.group_img = userObject["group_img"];
      userChat.group_topic = userObject["group_topic"];
      userChat.time = userObject["time"];
      userChat.count = userObject["count"];
      userChat.content = userObject["content"];
      userChat.type = userObject["type"].toString();
      userChat.list_member = (userObject['list_member'] as List<dynamic>)
          .map((e) => FirebaseUser.fromJSON(e))
          .toList();
      if(isInChat){
        if(chatuserId == userObject['id'].toString()){
          return;
        }
      }
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(GlobalVariable.navState.currentContext!)
            .push(MaterialPageRoute(
                builder: (context) => FirebaseGroupChatScreen(
                      routeArgument: new RouteArgument(groupUser: userChat),
                    )));
      });
    }
  }
}


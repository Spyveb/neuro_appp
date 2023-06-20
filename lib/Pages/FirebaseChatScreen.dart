import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Controller/MatcheController.dart';
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/PlayerWidget.dart';
import 'package:neuro/Helper/full_photo.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Models/MessageUser.dart';
import 'package:neuro/Models/NeuroRequest.dart';
import 'package:neuro/Models/route_arguments.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class FirebaseChatScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  FirebaseChatScreen({Key? key, this.routeArgument}) : super(key: key);

  @override
  _FirebaseChatState createState() => _FirebaseChatState();
}

class _FirebaseChatState extends StateMVC<FirebaseChatScreen> {
  SharedPreferences? prefs;
  String? id;
  String groupChatId = "";
  String peerId = "";
  var messageCon = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  late MatcheController _con;

  _FirebaseChatState() : super(MatcheController(false)) {
    _con = controller as MatcheController;
  }

  List<DocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  int _limitIncrement = 20;

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(_scrollListener);
    readLocal();
  }

  String peerToken = "";

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    peerId = this.widget.routeArgument!.userChat!.id!;
    prefs!.setInt(this.widget.routeArgument!.userChat!.id!,
        DateTime.now().millisecondsSinceEpoch);
    id = prefs?.getString(Constant.USERID) ?? '';
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }
    print(groupChatId);
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'chattingWith': peerId});

    chatuserId = peerId;
    isInChat = true;
    FirebaseFirestore.instance
        .collection('users')
        .doc(peerId)
        .get()
        .then((value) => {
              if (value.data()!.containsKey("deviceToken"))
                {
                  peerToken = value.get("deviceToken"),
                }
            });

    if (mounted) setState(() {});
    bool result = await Record().hasPermission();
  }

  Future<void> onSendMessage(String content, int type) async {
    // type: 0 = text, 1 = image, 2 = voice,3 = time
    if (content.trim() != '') {
      messageCon.clear();

      var mapData = Map<String, Object>();
      mapData['idFrom'] = id!;
      mapData['idTo'] = peerId;
      mapData['timestamp'] = DateTime.now().millisecondsSinceEpoch;
      mapData['content'] = content;
      mapData['type'] = type;

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(documentReference, mapData);
      });

      /*
        toOther
       */
      var documentrecentReference = FirebaseFirestore.instance
          .collection('recentusers')
          .doc(id)
          .collection(id!)
          .doc(peerId);
      print("documentrecentReference ${documentrecentReference.path}");
      if (this.widget.routeArgument!.isMatches != null &&
          this.widget.routeArgument!.isMatches!) {
        mapData['nudgeSender'] = DateTime.now().millisecondsSinceEpoch;
      }

      mapData['nickname'] = this.widget.routeArgument!.userChat!.nickname!;
      mapData['photoUrl'] = this.widget.routeArgument!.userChat!.photoUrl!;

      if (this.widget.routeArgument!.userChat!.nudgeReceiver != null) {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          transaction.set(documentrecentReference, mapData);
        });
      } else {
        var tempref = await FirebaseFirestore.instance
            .collection('recentusers')
            .doc(id)
            .collection(id!)
            .doc(peerId)
            .get();
        if (tempref.exists) {
          await FirebaseFirestore.instance.runTransaction((transaction) async {
            transaction.update(documentrecentReference, mapData);
          });
        } else {
          await FirebaseFirestore.instance.runTransaction((transaction) async {
            transaction.set(documentrecentReference, mapData);
          });
        }
      }
      /*
        toMe
       */
      var documentrecentReferencetoFrom = FirebaseFirestore.instance
          .collection('recentusers')
          .doc(peerId)
          .collection(peerId)
          .doc(id);
      print(
          "documentrecentReferencetoFrom ${documentrecentReferencetoFrom.path}");
      String? image = prefs!.getString(Constant.PROFILEIMAGE);
      String? name = prefs!.getString(Constant.NAME);
      var mapDatatoFrom = Map<String, Object>();
      mapDatatoFrom['idFrom'] = id!;
      mapDatatoFrom['idTo'] = peerId;
      mapDatatoFrom['timestamp'] = DateTime.now().millisecondsSinceEpoch;
      mapDatatoFrom['content'] = content;
      mapDatatoFrom['type'] = type;
      mapDatatoFrom['nickname'] = name!;
      mapDatatoFrom['photoUrl'] = image!;
      if (this.widget.routeArgument!.isMatches != null &&
          this.widget.routeArgument!.isMatches!) {
        mapDatatoFrom['nudgeReceiver'] = DateTime.now().millisecondsSinceEpoch;
      }

      if (this.widget.routeArgument!.userChat!.nudgeReceiver != null) {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          transaction.set(documentrecentReferencetoFrom, mapDatatoFrom);
        });
      } else {
        var tempref = await FirebaseFirestore.instance
            .collection('recentusers')
            .doc(peerId)
            .collection(peerId)
            .doc(id)
            .get();
        if (tempref.exists) {
          await FirebaseFirestore.instance.runTransaction((transaction) async {
            transaction.update(documentrecentReferencetoFrom, mapDatatoFrom);
          });
        } else {
          await FirebaseFirestore.instance.runTransaction((transaction) async {
            transaction.set(documentrecentReferencetoFrom, mapDatatoFrom);
          });
        }
      }

      prefs!.setInt(this.widget.routeArgument!.userChat!.id!,
          DateTime.now().millisecondsSinceEpoch);
      String chatContent = "";
      if (type == 0) {
        chatContent = content;
      } else if (type == 1) {
        chatContent = "Image";
      } else if (type == 2) {
        chatContent = "Voice";
      }
      MessageUser userSendChat = new MessageUser(id, image, name);
      var mapNotifcation = Map<String, dynamic>();
      mapNotifcation['data'] = {
        "title": "${name}",
        "body": "${chatContent}",
        "status": "chat",
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "userObject": userSendChat.ToJson(),
      };
      mapNotifcation["notification"] = {
        "title": "${name}",
        "body": "${chatContent}",
      };
      mapNotifcation["priority"] = "high";
      mapNotifcation['to'] = peerToken;
      _con.sendNotifcation(mapNotifcation);

      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);

      if (this.widget.routeArgument!.isMatches != null &&
          this.widget.routeArgument!.isMatches!) {
        this.widget.routeArgument!.isMatches = false;
        setState(() {});
        NeuroRequest sendData = new NeuroRequest();
        sendData.type = "1";
        sendData.id = peerId;
        _con.removeMatches(sendData);
      }
    }
  }

  File? imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = "";

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile;

    pickedFile = await imagePicker.getImage(
        source: ImageSource.gallery, maxWidth: 300, imageQuality: 70);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadFile();
      }
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile!);

    try {
      uploadTask.snapshotEvents.listen((event) {
        double progress =
            event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
        if (progress != 1.0) {
          uploadCount = progress;
          uploadString = "Upload Image";
          setState(() {});
        } else {
          Future.delayed(const Duration(milliseconds: 1500), () async {
            uploadCount = 0.0;
            uploadString = "";
            setState(() {});
          });
        }
      }).onError((error) {});
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  final _audioRecorder = Record();

  @override
  void dispose() {
    chatuserId = "";
    isInChat = false;
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    Helper.showToast("Recording start");
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String filePath = '${tempPath}/file_music.m4a';
    if (await File(filePath).exists()) {
      await File(filePath).delete();
    }
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start(path: filePath, encoder: AudioEncoder.AAC);
        bool isRecording = await _audioRecorder.isRecording();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stop() async {
    Helper.showToast("Recording stop");
    final player = AudioPlayer();
    final path = await _audioRecorder.stop();
    var duration = await player.setFilePath(path!);
    if (duration!.inSeconds > 5) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = reference.putFile(new File(path));
      String audiourl = "";
      try {
        uploadTask.snapshotEvents.listen((event) {
          double progress =
              event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
          if (progress != 1.0) {
            uploadCount = progress;
            uploadString = "Upload Voice";
            setState(() {});
          } else {
            Future.delayed(const Duration(milliseconds: 1500), () async {
              uploadCount = 0.0;
              uploadString = "";
              setState(() {});
            });
          }
        }).onError((error) {});
        TaskSnapshot snapshot = await uploadTask;
        audiourl = await snapshot.ref.getDownloadURL();
        setState(() {
          isLoading = false;
          onSendMessage(audiourl, 2);
        });
      } on FirebaseException catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Helper.showToast("Please record atleast for 5 seconds");
      return;
    }
  }

  bool _isLoading = false;
  DocumentSnapshot? lastMessage;
  DocumentSnapshot? templastMessage;

  loadToTrue() {
    _isLoading = true;
    FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((onData) {
      print("Something change");
      if (onData.docs[0].exists) {
        // Here i check if last array message is the last of the FireStore DB
        int equal = lastMessage!.id.compareTo(onData.docs[0].id);
        if (equal != 0) {
          setState(() {
            //_isLoading = false;
            _newMessageListener();
            listScrollController.animateTo(0.0,
                duration: Duration(milliseconds: 300), curve: Curves.easeOut);
          });
        }
      }
    });
  }

  _newMessageListener() {
    if (lastMessage == templastMessage) {
      return;
    }
    templastMessage = lastMessage;
    FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .where('timestamp',
            isGreaterThan:
                lastMessage != null ? lastMessage!.get("timestamp") : 0)
        .orderBy('timestamp', descending: true)
        .get()
        .then((event) {
      setState(() {
        listMessage.insertAll(0, event.docs);
        lastMessage = listMessage[0];
        prefs!.setInt(this.widget.routeArgument!.userChat!.id!,
            DateTime.now().millisecondsSinceEpoch);
      });
    });
  }

  _scrollListener() {
    // if _scroll reach top
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      // Query old messages
      FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .where('timestamp', isLessThan: listMessage.last.get("timestamp"))
          .orderBy('timestamp', descending: true)
          .limit(20)
          .get()
          .then((snapshot) {
        setState(() {
          loadToTrue();
          // And add to the list
          listMessage.addAll(snapshot.docs);
        });
      });
    }
  }

  double uploadCount = 0.0;
  String uploadString = "";

  _buildList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ChatMessageView(
          index,
          listMessage[index],
          id,
          this.widget.routeArgument!.userChat!.photoUrl!,
        );
      },
      itemCount: listMessage.length,
      controller: listScrollController,
      reverse: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Scaffold(
      key: _con.scaffoldKey,
      backgroundColor: Helper.hexToColor("#E5E5E5"),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(getProportionateScreenHeight(65)),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false, // hides leading widget
            flexibleSpace: SafeArea(
                child: Stack(
              fit: StackFit.expand,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context, "1");
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
                    Container(
                      margin: EdgeInsets.only(
                          left: getProportionateScreenWidth(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/FeedsDetails',
                                  arguments: new RouteArgument(
                                      isMatches: false,
                                      FeedId: this
                                          .widget
                                          .routeArgument!
                                          .userChat!
                                          .id!,
                                      isNormal: true));
                            },
                            child: Container(
                              child: Text(
                                  this
                                      .widget
                                      .routeArgument!
                                      .userChat!
                                      .nickname!,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: getProportionalFontSize(14),
                                      fontFamily: 'poppins',
                                      fontWeight: FontWeight.w700,
                                      color: Helper.hexToColor("#000000"))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.more_vert,
                          color: Helper.hexToColor("#5BAEE2"),
                        )),
                    Container(
                      width: getProportionateScreenWidth(30),
                    ),
                  ],
                ),
              ],
            )),
          )),
      body: Stack(
        children: [
          Column(
            children: [
              uploadCount != 0.0
                  ? Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 50,
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Divider(
                              height: getProportionateScreenHeight(1),
                              thickness: 1,
                              color: Helper.hexToColor("#5BAEE2"),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: getProportionateScreenWidth(15),
                                  right: getProportionateScreenWidth(15),
                                  top: getProportionateScreenHeight(7)),
                              child: Text(uploadString,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: getProportionalFontSize(14),
                                      fontFamily: 'poppins',
                                      fontWeight: FontWeight.w700,
                                      color: Helper.hexToColor("#000000"))),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: getProportionateScreenWidth(15),
                                  right: getProportionateScreenWidth(15),
                                  top: getProportionateScreenHeight(7)),
                              child: LinearProgressIndicator(
                                value: uploadCount,
                                backgroundColor: Helper.hexToColor("#E5E5E5"),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Helper.hexToColor("#F26336"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              Flexible(
                child: Container(
                    margin:
                        EdgeInsets.only(top: getProportionateScreenHeight(5)),
                    //height: getProportionateScreenHeight(630),
                    child: groupChatId.isNotEmpty
                        ? StreamBuilder<QuerySnapshot>(
                            stream: _isLoading
                                ? null
                                : FirebaseFirestore.instance
                                    .collection('messages')
                                    .doc(groupChatId)
                                    .collection(groupChatId)
                                    .orderBy('timestamp', descending: true)
                                    .limit(20)
                                    .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData && !_isLoading) {
                                this.widget.routeArgument!.userChat!.count = "";

                                listMessage = (snapshot.data!.docs);
                                if (listMessage.isNotEmpty)
                                  lastMessage = listMessage[0];
                                print(
                                    "main list ${snapshot.data!.docs.length}");
                                prefs!.setInt(
                                    this.widget.routeArgument!.userChat!.id!,
                                    DateTime.now().millisecondsSinceEpoch);
                              }
                              return _buildList();
                            },
                          )
                        : Container()),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: getProportionateScreenHeight(73),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    /*borderRadius: BorderRadius.only(
                        topRight:
                            Radius.circular(getProportionateScreenWidth(12)),
                        topLeft:
                            Radius.circular(getProportionateScreenWidth(12))),*/
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: getProportionateScreenWidth(21),
                          ),
                          GestureDetector(
                            onTap: () {
                              getImage();
                            },
                            child: SvgPicture.asset(
                              "assets/images/camera.svg",
                              height: getProportionateScreenWidth(18),
                            ),
                          ),
                          Container(
                            width: getProportionateScreenWidth(15.24),
                          ),
                          GestureDetector(
                            onLongPress: () {
                              _start();
                            },
                            onLongPressEnd: (val) {
                              _stop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SvgPicture.asset(
                                "assets/images/record_icon.svg",
                                height: getProportionateScreenWidth(18),
                              ),
                            ),
                          ),
                          /*GestureDetector(
                            onLongPress: () {
                              Helper.showToast("Recording Start");
                              print('start recording');
                              _start();
                            },
                            onLongPressUp: () {
                              Helper.showToast("Recording Stop");
                              print('stop recording');
                              _stop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SvgPicture.asset(
                                "assets/images/record_icon.svg",
                                height: getProportionateScreenWidth(18),
                              ),
                            ),
                          ),*/
                          Container(
                            width: getProportionateScreenWidth(15.13),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.57,
                            child: TextField(
                              onSubmitted: (value) {
                                onSendMessage(messageCon.text, 0);
                              },
                              controller: messageCon,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type a message",
                                hintStyle: TextStyle(
                                    fontSize: getProportionalFontSize(12),
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w400,
                                    color: Helper.hexToColor("#BFCAC5")),
                              ),
                              style: TextStyle(
                                  fontSize: getProportionalFontSize(12),
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w400,
                                  color: Helper.hexToColor("#000000")),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              onSendMessage(messageCon.text, 0);
                            },
                            child: SvgPicture.asset(
                              "assets/images/send.svg",
                              height: getProportionateScreenWidth(18),
                            ),
                          ),
                          Container(
                            width: getProportionateScreenWidth(21),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class ChatMessageView extends StatelessWidget {
  int index;
  DocumentSnapshot<Object?>? doc;
  String? userId;
  String photoUrl;

  ChatMessageView(this.index, this.doc, this.userId, this.photoUrl);

  @override
  Widget build(BuildContext context) {
    if (userId == this.doc!.get("idFrom").toString()) {
      if (this.doc!.get("type").toString() == "0") {
        return new Container(
          margin: EdgeInsets.only(
              bottom: getProportionateScreenHeight(10),
              left: getProportionateScreenWidth(107),
              right: getProportionateScreenWidth(18)),
          decoration: BoxDecoration(
            gradient: new LinearGradient(
              colors: [
                Helper.hexToColor("#5BAEE2"),
                Helper.hexToColor("#C078BA"),
              ],
              stops: [0.0, 1.0],
            ),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(getProportionateScreenWidth(16)),
                topLeft: Radius.circular(getProportionateScreenWidth(16)),
                bottomLeft: Radius.circular(getProportionateScreenWidth(16))),
          ),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: getProportionateScreenWidth(16),
                      right: getProportionateScreenWidth(16),
                      top: getProportionateScreenHeight(16),
                      bottom: getProportionateScreenHeight(8)),
                  child: Text(this.doc!.get("content"),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: getProportionalFontSize(13),
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w400,
                          color: Helper.hexToColor("#ffffff"))),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(
                      bottom: getProportionateScreenHeight(16),
                      right: getProportionateScreenWidth(16)),
                  child: Text(Helper.dayFormatter(this.doc!.get("timestamp")),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontSize: getProportionalFontSize(13),
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w400,
                          color: Helper.hexToColor("#ffffff"))),
                )
              ],
            ),
          ),
        );
      } else if (this.doc!.get("type").toString() == "1") {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        FullPhoto(url: this.doc!.get("content"))));
          },
          child: CachedNetworkImage(
            imageUrl: this.doc!.get("content"),
            fit: BoxFit.cover,
            width: getProportionateScreenWidth(218),
            height: getProportionateScreenWidth(218),
            imageBuilder: (context, imageProvider) => Container(
              margin: EdgeInsets.only(
                  bottom: getProportionateScreenHeight(10),
                  left: getProportionateScreenWidth(107),
                  right: getProportionateScreenWidth(18)),
              decoration: BoxDecoration(
                color: Helper.hexToColor("#E8BE9D"),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(getProportionateScreenWidth(16)),
                    topLeft: Radius.circular(getProportionateScreenWidth(16)),
                    bottomLeft:
                        Radius.circular(getProportionateScreenWidth(16)),
                    bottomRight:
                        Radius.circular(getProportionateScreenWidth(16))),
              ),
            ),
          ),
        );
      } else if (this.doc!.get("type").toString() == "2") {
        return PlayerWidget(url: this.doc!.get("content"));
      } else {
        return Container();
      }
    } else {
      if (this.doc!.get("type").toString() == "0") {
        return new Container(
          margin: EdgeInsets.only(
            bottom: getProportionateScreenHeight(10),
            left: getProportionateScreenWidth(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(70.0),
                  child: Container(
                    width: getProportionateScreenWidth(32),
                    height: getProportionateScreenWidth(32),
                    child: CachedNetworkImage(
                        width: getProportionateScreenWidth(32),
                        height: getProportionateScreenWidth(32),
                        fit: BoxFit.cover,
                        imageUrl: this.photoUrl),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: getProportionateScreenWidth(9.8),
                ),
                decoration: BoxDecoration(
                  color: Helper.hexToColor("#fffffff"),
                  borderRadius: BorderRadius.only(
                      topRight:
                          Radius.circular(getProportionateScreenWidth(16)),
                      bottomRight:
                          Radius.circular(getProportionateScreenWidth(16)),
                      bottomLeft:
                          Radius.circular(getProportionateScreenWidth(16))),
                ),
                child: Column(
                  children: [
                    Container(
                      width: getProportionateScreenWidth(218),
                      margin: EdgeInsets.only(
                          left: getProportionateScreenWidth(16),
                          right: getProportionateScreenWidth(16),
                          top: getProportionateScreenHeight(16),
                          bottom: getProportionateScreenHeight(8)),
                      child: Text(this.doc!.get("content"),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: getProportionalFontSize(13),
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                              color: Helper.hexToColor("#0000000"))),
                    ),
                    Container(
                      width: getProportionateScreenWidth(230),
                      margin: EdgeInsets.only(
                          bottom: getProportionateScreenHeight(16),
                          right: getProportionateScreenWidth(16)),
                      child: Text(
                          Helper.dayFormatter(this.doc!.get("timestamp")),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize: getProportionalFontSize(13),
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                              color: Helper.hexToColor("#A8A7A7"))),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      } else if (this.doc!.get("type").toString() == "1") {
        return Container(
          margin: EdgeInsets.only(
            bottom: getProportionateScreenHeight(10),
            left: getProportionateScreenWidth(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(70.0),
                  child: Container(
                    width: getProportionateScreenWidth(32),
                    height: getProportionateScreenWidth(32),
                    child: CachedNetworkImage(
                        width: getProportionateScreenWidth(32),
                        height: getProportionateScreenWidth(32),
                        fit: BoxFit.cover,
                        imageUrl: this.photoUrl),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FullPhoto(url: this.doc!.get("content"))));
                },
                child: Container(
                  width: getProportionateScreenWidth(250),
                  margin: EdgeInsets.only(
                    left: getProportionateScreenWidth(9.8),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: this.doc!.get("content"),
                    fit: BoxFit.cover,
                    width: getProportionateScreenWidth(218),
                    height: getProportionateScreenWidth(218),
                    imageBuilder: (context, imageProvider) => Container(
                      margin: EdgeInsets.only(
                        bottom: getProportionateScreenHeight(10),
                      ),
                      decoration: BoxDecoration(
                        color: Helper.hexToColor("#E8BE9D"),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(
                                getProportionateScreenWidth(16)),
                            topLeft: Radius.circular(
                                getProportionateScreenWidth(16)),
                            bottomLeft: Radius.circular(
                                getProportionateScreenWidth(16)),
                            bottomRight: Radius.circular(
                                getProportionateScreenWidth(16))),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (this.doc!.get("type").toString() == "2") {
        return Container(
          margin: EdgeInsets.only(
            bottom: getProportionateScreenHeight(10),
            left: getProportionateScreenWidth(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(70.0),
                  child: Container(
                    width: getProportionateScreenWidth(32),
                    height: getProportionateScreenWidth(32),
                    child: CachedNetworkImage(
                        width: getProportionateScreenWidth(32),
                        height: getProportionateScreenWidth(32),
                        fit: BoxFit.cover,
                        imageUrl: this.photoUrl),
                  ),
                ),
              ),
              PlayerWidgetLeft(
                  url: this.doc!.get("content"),
                  timeStamp: this.doc!.get("timestamp"))
            ],
          ),
        );
      } else {
        return Container();
      }
    }
  }
}

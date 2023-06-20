import 'dart:io';

import 'package:neuro/Models/Feed.dart';
import 'package:neuro/Models/FriendUser.dart';
import 'package:neuro/Models/Group.dart';
import 'package:neuro/Models/Matches.dart';
import 'package:neuro/Models/Profile.dart';
import 'package:neuro/Models/Register.dart';

import 'GroupUser.dart';
import 'MessageUser.dart';

class RouteArgument {
  bool? isMatches;
  bool? isNormal;
  Register? register;
  Feed? filterData;
  Profile? profile;
  Matches? matches;
  String? FeedId;
  List<FriendUser>? list_user;
  MessageUser? userChat;
  Group? groupInfo;
  String? groupID;
  List<dynamic>? list_personality = <dynamic>[];
  GroupUser? groupUser;
  bool? isFromEdit = false;
  File? file_frontphoto;
  String? mode;
  List<dynamic>? list_neurological_status = <dynamic>[];
  String? gender;
  bool? isVerified;
  bool? isTerms;
  String? neurologicalstatus;
  List<dynamic>? following_applies = <dynamic>[];
  bool? isNotification;
  RouteArgument(
      {this.isMatches,
      this.register,
      this.filterData,
      this.profile,
      this.matches,
      this.FeedId,
      this.list_user,
      this.userChat,
      this.groupInfo,
      this.list_personality,
      this.groupID,
      this.groupUser,
      this.isNormal,
      this.isFromEdit,
      this.file_frontphoto,
      this.mode,
      this.list_neurological_status,
      this.gender,
      this.isVerified,
      this.isTerms,
      this.neurologicalstatus,this.following_applies,this.isNotification});
}

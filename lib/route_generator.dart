import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'Models/route_arguments.dart';
import 'Pages/AboutMeAboutScreen.dart';
import 'Pages/AboutMeAgeScreen.dart';
import 'Pages/AboutMeChooseModeScreen.dart';
import 'Pages/AboutMeEmailScreen.dart';
import 'Pages/AboutMeMorePhotoScreen.dart';
import 'Pages/AboutMeNameScreen.dart';
import 'Pages/AboutMeNeurologicalScreen.dart';
import 'Pages/AboutMePersonalityScreen.dart';
import 'Pages/AboutMeProfilePictureScreen.dart';
import 'Pages/AboutMeYourIdentifyScreen.dart';
import 'Pages/AboutMeYourIdentifySpecifyScreen.dart';
import 'Pages/AboutNeurologicalStatusScreen.dart';
import 'Pages/BackIDVerificationScreen.dart';
import 'Pages/BuyNudegeScreen.dart';
import 'Pages/DashboardScreen.dart';
import 'Pages/EditGenderScreen.dart';
import 'Pages/EditGroupInfo.dart';
import 'Pages/EditNeuroLogicalStatusScreen.dart';
import 'Pages/EditNeuroStatusScreen.dart';
import 'Pages/EditPersonalityScreen.dart';
import 'Pages/EditProfileScreen.dart';
import 'Pages/FaceVerificationScreen.dart';
import 'Pages/FeedsDetailsScreen.dart';
import 'Pages/FeedsFilterScreen.dart';
import 'Pages/FirebaseChatScreen.dart';
import 'Pages/FirebaseGroupChatScreen.dart';
import 'Pages/FrontIDVerificationScreen.dart';
import 'Pages/GroupInfoScreen.dart';
import 'Pages/LoginScreen.dart';
import 'Pages/ManageScreen.dart';
import 'Pages/MatchScreen.dart';
import 'Pages/OtherGenderEditScreen.dart';
import 'Pages/PremiumPlanScreen.dart';
import 'Pages/SettingsScreen.dart';
import 'Pages/SignInEmailScreen.dart';
import 'Pages/SignUpEmailScreen.dart';
import 'Pages/TermsOfUseScreen.dart';
import 'Pages/TestPurchase.dart';
import 'Pages/TutorialScreen.dart';
import 'Pages/UserSelectionScreen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/SignUpEmail':
        return MaterialPageRoute(builder: (_) => SignUpEmailScreen());
      case '/SignInEmail':
        return MaterialPageRoute(builder: (_) => SignInEmailScreen());
      case '/AboutMeName':
        return MaterialPageRoute(
            builder: (_) =>
                AboutMeNameScreen(routeArgument: args as RouteArgument));
      case '/AboutMeEmail':
        return MaterialPageRoute(
            builder: (_) =>
                AboutMeEmailScreen(routeArgument: args as RouteArgument));
      case '/AboutMeProfilePicture':
        return MaterialPageRoute(
            builder: (_) => AboutMeProfilePictureScreen(
                routeArgument: args as RouteArgument));
      case '/AboutMeMorePhoto':
        return MaterialPageRoute(
            builder: (_) =>
                AboutMeMorePhotoScreen(routeArgument: args as RouteArgument));
      case '/AboutMeAge':
        return MaterialPageRoute(
            builder: (_) =>
                AboutMeAgeScreen(routeArgument: args as RouteArgument));
      case '/AboutMeAbout':
        return MaterialPageRoute(
            builder: (_) =>
                AboutMeAboutScreen(routeArgument: args as RouteArgument));
      case '/AboutMeYourIdentify':
        return MaterialPageRoute(
            builder: (_) => AboutMeYourIdentifyScreen(
                routeArgument: args as RouteArgument));
      case '/AboutMeYourIdentifySpecify':
        return MaterialPageRoute(
            builder: (_) => AboutMeYourIdentifySpecifyScreen(
                routeArgument: args as RouteArgument));
      case '/AboutMeChooseMode':
        return MaterialPageRoute(
            builder: (_) =>
                AboutMeChooseModeScreen(routeArgument: args as RouteArgument));
      case '/AboutNeurologicalStatus':
        return MaterialPageRoute(
            builder: (_) => AboutNeurologicalStatusScreen(
                routeArgument: args as RouteArgument));
      case '/AboutMeNeurological':
        return MaterialPageRoute(
            builder: (_) => AboutMeNeurologicalScreen(
                routeArgument: args as RouteArgument));
      case '/AboutMePersonality':
        return MaterialPageRoute(
            builder: (_) =>
                AboutMePersonalityScreen(routeArgument: args as RouteArgument));
      case '/Tutorial':
        return MaterialPageRoute(builder: (_) => TutorialScreen());
      case '/Dashboard':
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case '/FeedsFilter':
        return PageTransition(
            child: FeedsFilterScreen(routeArgument: args as RouteArgument),
            type: PageTransitionType.topToBottom);
      case '/FeedsDetails':
        return MaterialPageRoute(
            builder: (_) =>
                FeedsDetailsScreen(routeArgument: args as RouteArgument));
      case '/PremiumPlan':
        return MaterialPageRoute(builder: (_) => PremiumPlanScreen());
      case '/BuyNudege':
        return MaterialPageRoute(builder: (_) => BuyNudegeScreen());
      case '/GroupInfo':
        return MaterialPageRoute(
            builder: (_) =>
                GroupInfoScreen(routeArgument: args as RouteArgument));
      case '/Match':
        return MaterialPageRoute(
            builder: (_) => MatchScreen(routeArgument: args as RouteArgument));
      case '/EditProfile':
        return MaterialPageRoute(
            builder: (_) =>
                EditProfileScreen(routeArgument: args as RouteArgument));
      case '/UserSelection':
        return MaterialPageRoute(
            builder: (_) =>
                UserSelectionScreen(routeArgument: args as RouteArgument));
      case '/FirebaseChat':
        return MaterialPageRoute(
            builder: (_) =>
                FirebaseChatScreen(routeArgument: args as RouteArgument));
      case '/EditGroupInfo':
        return MaterialPageRoute(
            builder: (_) =>
                EditGroupInfo(routeArgument: args as RouteArgument));
      case '/EditPersonality':
        return MaterialPageRoute(
            builder: (_) =>
                EditPersonalityScreen(routeArgument: args as RouteArgument));
      case '/FirebaseGroupChat':
        return MaterialPageRoute(
            builder: (_) =>
                FirebaseGroupChatScreen(routeArgument: args as RouteArgument));
      case '/FaceVerification':
        return MaterialPageRoute(
            builder: (_) =>
                FaceVerificationScreen(routeArgument: args as RouteArgument));
      case '/FrontIDVerification':
        return MaterialPageRoute(
            builder: (_) => FrontIDVerificationScreen(
                routeArgument: args as RouteArgument));
      case '/BackIDVerification':
        return MaterialPageRoute(
            builder: (_) =>
                BackIDVerificationScreen(routeArgument: args as RouteArgument));
      case '/Settings':
        return MaterialPageRoute(
            builder: (_) =>
                SettingsScreen(routeArgument: args as RouteArgument));
      case '/TestPurchase':
        return MaterialPageRoute(builder: (_) => TestPurchase());
      case '/EditNeuroLogicalStatus':
        return MaterialPageRoute(
            builder: (_) => EditNeuroLogicalStatusScreen(
                routeArgument: args as RouteArgument));
      case '/EditGender':
        return MaterialPageRoute(
            builder: (_) =>
                EditGenderScreen(routeArgument: args as RouteArgument));
      case '/OtherGenderEdit':
        return MaterialPageRoute(
            builder: (_) =>
                OtherGenderEditScreen(routeArgument: args as RouteArgument));
      case '/TermsOfUseOrPolicyScreen':
        return MaterialPageRoute(
            builder: (_) =>
                TermsOfUseScreen(routeArgument: args as RouteArgument));
      case '/EditNeuroStatusScreen':
        return MaterialPageRoute(
            builder: (_) =>
                EditNeuroStatusScreen(routeArgument: args as RouteArgument));
      case '/ManageScreen':
        return MaterialPageRoute(
            builder: (_) =>
                ManageScreen(routeArgument: args as RouteArgument));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: SafeArea(
                    child: Text("Route Error !!"),
                  ),
                ));
    }
  }
}

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/PaymentService.dart';
import 'package:neuro/Models/Register.dart';
import 'package:neuro/Models/route_arguments.dart';
import 'package:neuro/Repository/RegisterRepository.dart' as repoLogin;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginController extends ControllerMVC {
  late GlobalKey<ScaffoldState> scaffoldKey;
  late OverlayEntry loader;
  Register sendLogin = new Register();

  LoginController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    loader = Helper.overlayLoader(this.scaffoldKey.currentContext);
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    var appleCredential;
    try {
      appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
    } catch (e) {
      loader.remove();
      Helper.hideLoader(loader);
    }

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      loader.remove();
      Helper.hideLoader(loader);
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult result = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
    } catch (e) {
      print(e);
    }
  }

  void userLogin() async {
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoLogin
                  .userLogin(this.sendLogin)
                  .then((value) => {
                        if (value.isDone)
                          {
                            PaymentService().initConnection(),
                            //Helper.showToast(value.error),
                            Navigator.pop(this.scaffoldKey.currentContext!),
                            Navigator.pushNamedAndRemoveUntil(
                                this.scaffoldKey.currentContext!,
                                '/Dashboard',
                                (route) => false),
                          }
                        else
                          {
                            Helper.showToast(value.error),
                          },
                        setState(() {}),
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

  void userEmailCheck(Register sendDataNewScreen) async {
    FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoLogin
                  .userEmailCheck(this.sendLogin)
                  .then((value) => {
                        if (value.isDone)
                          {
                            Navigator.pushNamed(
                                this.scaffoldKey.currentContext!,
                                '/AboutMeName',
                                arguments: new RouteArgument(
                                    register: sendDataNewScreen)),
                          }
                        else
                          {
                            Helper.showToast(value.error),
                          },
                        setState(() {}),
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

  void userSocialLogin(Register sendData) async {
    /*FocusScope.of(this.scaffoldKey.currentContext!).unfocus();
    Overlay.of(this.scaffoldKey.currentContext!)!.insert(loader);*/
    Helper.isConnect().then((value) => {
          if (value)
            {
              repoLogin
                  .userSociallogin(sendData)
                  .then((value) => {
                        if (value.isDone)
                          {
                            PaymentService().initConnection(),
                            //Helper.showToast(value.error),
                            Navigator.pop(this.scaffoldKey.currentContext!),
                            Navigator.pushNamedAndRemoveUntil(
                                this.scaffoldKey.currentContext!,
                                '/Dashboard',
                                (route) => false),
                          }
                        else
                          {
                            // Helper.showToast(value.error),
                            Navigator.pushNamed(
                                this.scaffoldKey.currentContext!,
                                '/AboutMeEmail',
                                arguments:
                                    new RouteArgument(register: sendData)),
                          },
                        setState(() {}),
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

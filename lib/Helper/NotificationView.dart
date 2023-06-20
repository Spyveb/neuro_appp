import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neuro/Helper/size_config.dart';

typedef NotificationOViewCallback = void Function(bool status);

class NotificationView extends StatelessWidget {
  final String title;
  final String subTitle;
  final NotificationOViewCallback onTap;

  NotificationView({this.title = "", this.subTitle = "", required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return Material(
        color: Theme.of(context).backgroundColor,
        child: SafeArea(
          child: GestureDetector(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: 15,
                      left: 16,
                      right: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 25,
                              child: ClipRRect(
                                child:
                                    Image.asset('assets/images/logoplain.png'),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Neuro",
                              style: this._getStyle(context),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 6)),
                        Text(
                          this.subTitle,
                          style: this._getStyle(context),
                          maxLines: 3,
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                      ],
                    ),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              color: Colors.transparent,
              width: double.infinity,
            ),
            onTap: () {
              if (this.onTap != null) {
                this.onTap(true);
              }
            },
          ),
          bottom: false,
        ),
      );
    } else {
      return Material(
        color: Theme.of(context).bottomAppBarColor,
        child: GestureDetector(
          child: SafeArea(
            child: Container(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 25,
                          child: ClipRRect(
                            child: Image.asset('assets/images/logoplain.png'),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          "Neuro",
                          style: this._getStyle(context),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 6)),
                    Text(
                      this.subTitle,
                      style: this._getStyle(context),
                      maxLines: 3,
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Theme.of(context).bottomAppBarColor,
                    boxShadow: kElevationToShadow[2]),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Theme.of(context).bottomAppBarColor,
                  boxShadow: kElevationToShadow[2]),
              margin: EdgeInsets.all(10.0),
              width: double.infinity,
            ),
            bottom: false,
          ),
          onTap: () {
            if (this.onTap != null) {
              this.onTap(true);
            }
          },
        ),
      );
    }
  }

  TextStyle _getStyle(BuildContext context) {
    return TextStyle(
        color: Colors.black,
        fontFamily: 'poppins',
        fontWeight: FontWeight.w500,
        fontSize: (15));
  }
}

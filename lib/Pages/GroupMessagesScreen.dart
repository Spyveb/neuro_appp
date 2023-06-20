import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Widget/CreateGroupView.dart';
import 'package:neuro/Widget/GroupMessageInboxView.dart';
import 'package:neuro/Widget/GroupMessageRequestView.dart';

class GroupMessagesScreen extends StatefulWidget {
  @override
  _GroupMessagesState createState() => _GroupMessagesState();
}

class _GroupMessagesState extends StateMVC<GroupMessagesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  var _selectedTabbar = 0;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(getProportionateScreenHeight(45)),
        child: SafeArea(
          child: TabBar(
            onTap: (index) {
              print(index);
              setState(() {
                _selectedTabbar = index;
              });
            },
            tabs: <Widget>[
              Container(
                  //width: MediaQuery.of(context).size.width / 4,
                  alignment: Alignment.center,
                  child: Text(
                    "My Group Chats",
                    textAlign: TextAlign.center,
                  )),
              Container(
                  //width: MediaQuery.of(context).size.width / 4,
                  alignment: Alignment.center,
                  child: Text(
                    "My Group Requests",
                    textAlign: TextAlign.center,
                  )),
              Container(
                  //width: MediaQuery.of(context).size.width / 4,
                  alignment: Alignment.center,
                  child: Text(
                    "New Group",
                    textAlign: TextAlign.center,
                  )),
            ],
            isScrollable: false,
            unselectedLabelColor: Helper.hexToColor("#A8A7A7"),
            labelColor: Helper.hexToColor("#5BAEE2"),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Helper.hexToColor("#5BAEE2"),
            controller: _tabController,
            labelStyle: TextStyle(
              fontSize: getProportionalFontSize(10),
              fontFamily: 'poppins',
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: getProportionalFontSize(10),
              fontFamily: 'poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      /*body: Container(
        color: Helper.hexToColor("#E5E5E5"),
        child: Builder(builder: (_) {
          if (_tabController.index == 0) {
            return GroupMessageInboxView();
          } else if (_tabController.index == 1) {
            return GroupMessageRequestView();
          } else if (_tabController.index == 2) {
            return CreateGroupView(_tabController);
          } else {
            return Container();
          }
        }),
      ),*/
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          GroupMessageInboxView(),
          GroupMessageRequestView(),
          CreateGroupView(_tabController),
        ],
      ),
    );
  }
}

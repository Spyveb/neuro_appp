import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:neuro/Helper/Constant.dart';
import 'package:neuro/Helper/Helper.dart';
import 'package:neuro/Helper/size_config.dart';
import 'package:neuro/Widget/MessageInboxView.dart';
import 'package:neuro/Widget/MessageMatchesView.dart';
import 'package:neuro/Widget/MessageNeuroRequestView.dart';
import 'package:neuro/Widget/MessageSentRequestView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends StateMVC<MessagesScreen>
    with TickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[
    new Tab(text: "Inbox"),
    new Tab(text: "Matches"),
    new Tab(text: "Requests"),
    //new Tab(text: "Sent Requests"),
  ];
  late TabController _tabController;
  var _selectedTabbar = 0;

  bool isPrime = false;

  getPrimeStatus() async {
    var prefs = await SharedPreferences.getInstance();
    isPrime = prefs.getBool(Constant.ISPRIME)!;
    setState(() {});
  }

  @override
  void initState() {
    getPrimeStatus();
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
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
            onTap: (index) async {
              print(index);
              if(!isPrime){
                if(index == 2){
                  _tabController.animateTo(_selectedTabbar);
                  Helper.showToast(
                      "Please purchase premium membership for full access");
                  final result =
                      await Navigator.pushNamed(context, '/PremiumPlan');
                  await getPrimeStatus();
                  if(isPrime){
                    setState(() {
                      _selectedTabbar = 2;
                    });
                    _tabController.animateTo(_selectedTabbar);
                  }
                  return;
                }else{
                  setState(() {
                    _selectedTabbar = index;
                  });
                }
              }else{
                setState(() {
                  _selectedTabbar = index;
                });
              }
            },
            tabs: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width / 4,
                  alignment: Alignment.center,
                  child: Text(
                    "Inbox",
                  )),
              Container(
                  width: MediaQuery.of(context).size.width / 4,
                  alignment: Alignment.center,
                  child: Text(
                    "Matches",
                  )),
              Container(
                  width: MediaQuery.of(context).size.width / 4,
                  alignment: Alignment.center,
                  child: Text(
                    "Requests",
                    textAlign: TextAlign.center,
                  )),
              /*Container(
                  width: MediaQuery.of(context).size.width / 4,
                  alignment: Alignment.center,
                  child: Text(
                    "Sent Request",
                  ))*/
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
      body: Container(
        child: Builder(builder: (_) {
          if (_selectedTabbar == 0) {
            return MessageInboxView();
          } else if (_selectedTabbar == 1) {
            return MessageMatchesView();
          } else if (_selectedTabbar == 2) {
            return MessageNeuroRequestView();
          } else {
            //return MessageSentRequestView();
            return new Container();
          }
        }),
      ),
    );
  }
}

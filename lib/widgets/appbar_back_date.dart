import 'dart:ui';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../Authentication/login_register.dart';
import '../authentication/authservice.dart';
import '../screen/dailyreport/daily_project.dart';
import '../style.dart';

class CustomAppBarBackDate extends StatefulWidget {
  String? text;
  String? appbardate;
  // final IconData? icon;
  final bool haveCalender;
  final bool haveSynced;
  final bool haveSummary;
  final void Function()? store;
  VoidCallback? onTap;
  final void Function()? choosedate;
  bool havebottom;
  bool havedropdown;
  bool isdetailedTab;

  TabBar? tabBar;

  CustomAppBarBackDate(
      {super.key,
      this.text,
      this.appbardate,
      this.haveSynced = false,
      this.haveSummary = false,
      this.haveCalender = false,
      this.store,
      this.onTap,
      this.choosedate,
      this.havedropdown = false,
      this.havebottom = false,
      this.isdetailedTab = false,
      this.tabBar});

  @override
  State<CustomAppBarBackDate> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBarBackDate> {
  dynamic userId;
  String? rangeStartDate = DateFormat.yMMMMd().format(DateTime.now());

  @override
  void initState() {
    getUserId().whenComplete(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        titleSpacing: 0,
        bottomOpacity: 3.0,
        backgroundColor: blue,
        title: Text(
          widget.text.toString(),
          maxLines: 3,
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          widget.haveCalender
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        widget.choosedate!();
                      },
                      child: Image.asset(
                        'assets/appbar/calender.jpeg',
                        height: 35,
                        width: 35,
                      ),
                    ),
                    // child: const Icon(Icons.calendar_today, size: 25)),
                    Text(
                      showDate!,
                      style: TextStyle(color: white, fontSize: 10),
                    ),
                  ],
                )
              : Container(),
          Container(
            padding: const EdgeInsets.only(bottom: 8, right: 5),
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.haveSummary
                    ? InkWell(
                        onTap: widget.onTap,
                        child: Image.asset(
                          'assets/appbar/summary.jpeg',
                          height: 35,
                          width: 35,
                        ),
                      )
                    : widget.haveSynced
                        ? InkWell(
                            onTap: () {
                              widget.store!();
                            },
                            child: Image.asset(
                              'assets/appbar/sync.jpeg',
                              height: 35,
                              width: 35,
                            ),
                          )
                        : Container()
              ],
            ),
          )
        ],
        bottom: widget.havebottom
            ? TabBar(
                labelColor: Colors.yellow,
                labelStyle: buttonWhite,
                unselectedLabelColor: white,

                //indicatorSize: TabBarIndicatorSize.label,
                indicator: MaterialIndicator(
                  horizontalPadding: 24,
                  bottomLeftRadius: 8,
                  bottomRightRadius: 8,
                  color: black,
                  paintingStyle: PaintingStyle.fill,
                ),

                tabs: const [
                  Tab(text: "PSS"),
                  Tab(text: "RMU"),
                  Tab(text: "PSS"),
                  Tab(text: "RMU"),
                  Tab(text: "PSS"),
                  Tab(text: "RMU"),
                  Tab(text: "PSS"),
                  Tab(text: "RMU"),
                  Tab(text: "PSS"),
                ],
              )
            : widget.isdetailedTab
                ? TabBar(
                    labelColor: Colors.yellow,
                    labelStyle: buttonWhite,
                    unselectedLabelColor: white,

                    //indicatorSize: TabBarIndicatorSize.label,
                    indicator: MaterialIndicator(
                      horizontalPadding: 24,
                      bottomLeftRadius: 8,
                      bottomRightRadius: 8,
                      color: black,
                      paintingStyle: PaintingStyle.fill,
                    ),

                    tabs: const [
                      Tab(text: "RFC Drawings of Civil Activities"),
                      Tab(text: "EV Layout Drawings of Electrical Activities"),
                      Tab(text: "Shed Lighting Drawings & Specification"),
                    ],
                  )
                : widget.tabBar);
  }

  Future<bool> onWillPop(BuildContext context) async {
    bool a = false;
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Close TATA POWER?",
                      style: subtitle1White,
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              //color: blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            //color: blue,
                            child: Center(
                                child: Text(
                              "No",
                              style: button.copyWith(color: blue),
                            )),
                          ),
                        )),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            a = true;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginRegister(),
                                ));
                            // exit(0);
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            //color: blue,
                            child: Center(
                                child: Text(
                              "Yes",
                              style: button,
                            )),
                          ),
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ));
    return a;
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }
}

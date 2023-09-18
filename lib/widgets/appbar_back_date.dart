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
      this.haveSynced = false,
      this.haveSummary = false,
      this.haveCalender = true,
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
              ? Container(
                  height: 25,
                  width: 80,
                  child: Column(
                    children: [
                      InkWell(
                          onTap: () {
                            widget.choosedate!();
                          },
                          child: const Icon(Icons.calendar_today, size: 20)),
                      Text(
                        showDate!,
                        style: TextStyle(color: white, fontSize: 10),
                      ),
                    ],
                  ),
                )
              : Container(),
          widget.haveSummary
              ? Container(
                  padding: const EdgeInsets.only(left: 5, right: 2),
                  height: 25,
                  width: 55,
                  child: InkWell(
                    onTap: widget.onTap,
                    child: Column(
                      children: const [
                        Icon(
                          Icons.summarize_sharp,
                          size: 20,
                        ),
                        Text(
                          'Summary',
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ))
              : Container(),
          widget.haveSynced
              ? InkWell(
                  onTap: () => widget.store!(),
                  child: Container(
                      height: 25,
                      width: 40,
                      child: Column(
                        children: const [
                          Icon(Icons.sync, size: 20),
                          Text(
                            'Sync',
                            style: TextStyle(fontSize: 10),
                          )
                        ],
                      )
                      //  ListTile(
                      //   onTap: () => widget.store!(),
                      //   title: Icon(
                      //     Icons.sync_lock_rounded,
                      //     color: white,
                      //     size: 20,
                      //   ),
                      //   subtitle: Padding(
                      //     padding: const EdgeInsets.only(bottom: 15, right: 0),
                      //     child: Text(
                      //       'Sync',
                      //       style: TextStyle(color: white, fontSize: 10),
                      //       textAlign: TextAlign.center,
                      //     ),
                      //   ),
                      // ),
                      ),
                )
              : Container()
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

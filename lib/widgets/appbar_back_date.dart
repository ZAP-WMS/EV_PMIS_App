import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../style.dart';
import '../views/authentication/authservice.dart';
import '../views/authentication/login_register.dart';

class CustomAppBarBackDate extends StatefulWidget {
  String? text;
  String? showDate;
  String? appbardate;
  String? depoName;
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
  bool isDownload;
  Function()? downloadFun;

  CustomAppBarBackDate(
      {super.key,
      this.text,
      this.showDate,
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
      this.tabBar,
      required this.depoName,
      this.isDownload = false,
      this.downloadFun});

  @override
  State<CustomAppBarBackDate> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBarBackDate> {
  dynamic userId;
  String? rangeStartDate = DateFormat.yMMMMd().format(DateTime.now());

  @override
  void initState() {
    widget.showDate = DateFormat.yMMMd().format(DateTime.now());
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
        title: Column(
          children: [
            Text(
              widget.text.toString(),
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.depoName ?? '',
              style: const TextStyle(
                fontSize: 11,
              ),
            ),
          ],
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
                      widget.showDate!,
                      style: TextStyle(color: white, fontSize: 10),
                    ),
                  ],
                )
              : Container(),
          Container(
            padding: const EdgeInsets.only(bottom: 0, right: 5),
            width: widget.haveSummary ? 80 : 50,
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
                    : Text(''),
                widget.haveSynced
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
          ),
          widget.isDownload
              ? InkWell(
                  onTap: widget.downloadFun,
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 8, bottom: 8, right: 5, left: 5.0),
                    width: 50,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      Icons.download,
                      color: blue,
                    ),
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

import 'package:ev_pmis_app/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../provider/key_provider.dart';
import '../views/authentication/login_register.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  String title;
  final double height;
  bool isSync = false;
  bool isCentered = true;
  bool isprogress;
  bool haveupload;
  String? depoName;
  final void Function()? store;
  CustomAppBar({
    super.key,
    required this.title,
    required this.height,
    this.isprogress = false,
    required this.isSync,
    this.haveupload = false,
    required this.isCentered,
    this.store,
    this.depoName,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: widget.isCentered ? true : false,
      title: Column(
        children: [
          Text(
            widget.title,
            // maxLines: 2,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.depoName!,
            style: const TextStyle(fontSize: 11),
          )
        ],
      ),
      backgroundColor: blue,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(2))),
      actions: [
        widget.isprogress
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 230,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          legends(yellow, 'Base Line', black),
                          legends(green, 'On Time', black),
                          legends(red, 'Delay', white),
                        ],
                      )),
                  Consumer<KeyProvider>(
                    builder: (context, value, child) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(bottom: 2, right: 5, left: 5),
                        child: Row(
                          children: [
                            Container(
                              width: 95,
                              height: 40,
                              color: green,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                    'Project Duration \n ${durationParse(value.startdate, value.endDate)} Days',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontSize: 10, color: black)),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              width: 95,
                              height: 40,
                              color: red,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                    'Project Delay \n ${durationParse(value.actualDate, value.endDate)}  Days ',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontSize: 10, color: white)),
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              '% Of Progress is ',
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(
                              height: 50.0,
                              width: 40.0,
                              child: CircularPercentIndicator(
                                radius: 20.0,
                                lineWidth: 4.0,
                                percent: (value.perProgress.toInt()) / 100,
                                center: Text(
                                  // value.getName.toString(),
                                  "${(value.perProgress.toInt())}% ",
                                  textAlign: TextAlign.center,
                                  style: captionWhite,
                                ),
                                progressColor: green,
                                backgroundColor: red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              )
            : Container(),

        // isConnected ? Container() : const NoInterneet(),
        // IconButton(
        //     onPressed: () {
        //       isConnected
        //           ? showAlertDialog(context)
        //           : Icons.signal_wifi_off;
        //     },
        //     icon: Icon(Icons.wifi)),

        widget.isSync
            ? InkWell(
                onTap: () {
                  widget.store!();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/appbar/sync.jpeg',
                    height: 25,
                    width: 35,
                  ),
                ),
              )
            : widget.haveupload
                ? Container(
                    padding: const EdgeInsets.all(5),
                    height: 30,
                    width: 130,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/material-excelpage');
                        },
                        child: Text(
                          'Upload Material Sheet',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: white, fontSize: 12),
                        )),
                  )
                : Container()
      ],
    );
  }

  Size get preferredSize => Size.fromHeight(widget.height);

  legends(Color color, String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: 70,
              height: 25,
              color: color,
              padding: const EdgeInsets.all(5),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: textColor,
                    fontSize: 10),
              )),
        ],
      ),
    );
  }

  int durationParse(String fromtime, String todate) {
    DateTime startdate = DateFormat('dd-MM-yyyy').parse(fromtime);
    DateTime enddate = DateFormat('dd-MM-yyyy').parse(todate);
    return enddate.add(const Duration(days: 1)).difference(startdate).inDays;
  }
}

Future<bool> onWillPop(BuildContext context) async {
  bool a = false;
  await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Close TATA POWER?",
                    style: subtitleWhite,
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
                            border: Border.all(color: blue),
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
                      const SizedBox(
                        width: 5,
                      ),
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

showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Alert Dialog Title'),
        content: const Text('This is the content of the alert dialog.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

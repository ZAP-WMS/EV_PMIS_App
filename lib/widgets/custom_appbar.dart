import 'package:ev_pmis_app/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/checkbox_provider.dart';
import '../provider/key_provider.dart';
import '../views/authentication/login_register.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final bool isSync;
  final bool isCentered;
  final bool isprogress;
  final bool haveupload;
  final String? depoName;
  final bool isDownload;
  void Function()? downloadFun;
  final void Function()? store;
  final bool haveSend;
  final void Function()? sendEmail;

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
    this.isDownload = false,
    this.downloadFun,
    this.sendEmail,
    this.haveSend = false,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: widget.height,
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
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(
            2,
          ),
        ),
      ),
      actions: [
        widget.haveSend
            ? Consumer<CheckboxProvider>(
                builder: (context, value, child) {
                  // print(value.myBooleanValue);
                  return Padding(
                      padding: const EdgeInsets.all(8),
                      child: IconButton(
                        onPressed: widget.sendEmail,
                        icon: Icon(
                          Icons.share,
                          color: white,
                        ),
                      ));
                },
              )
            : Container(),
        widget.isprogress
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      legends(yellow, 'Base Line', black),
                      legends(green, 'On Time', black),
                      legends(red, 'Delay', white),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Consumer<KeyProvider>(
                    builder: (context, value, child) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(bottom: 2, right: 5, left: 5),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 140,
                                  height: 28,
                                  color: green,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                        'Project Duration ${durationParse(value.startdate, value.endDate)} Days',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 10, color: black)),
                                  ),
                                ),
                                Container(
                                  width: 140,
                                  height: 27,
                                  color: red,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Project Delay ${durationParse(
                                        value.actualDate,
                                        value.endDate,
                                      )} Days ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Column(
                              children: [
                                const Text(
                                  'Progress %',
                                  style: TextStyle(fontSize: 10),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  height: 40.0,
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
                : Container(),

        widget.isDownload
            ? InkWell(
                onTap: widget.downloadFun,
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10, right: 5),
                  width: 50,
                  height: 50,
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
    );
  }

  legends(Color color, String title, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            alignment: Alignment.center,
            width: 70,
            height: 18,
            color: color,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w900, color: textColor, fontSize: 10),
            )),
      ],
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
                    "Logout TATA POWER?",
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
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.remove('cities');
                          await prefs.remove('role');
                          await prefs.remove('employeeId');
                          a = true;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginRegister(),
                            ),
                          );
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

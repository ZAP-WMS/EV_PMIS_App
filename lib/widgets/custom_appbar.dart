import 'package:ev_pmis_app/style.dart';
import 'package:flutter/material.dart';

import '../authentication/login_register.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  String title;
  final double height;
  bool isSync = false;
  bool isCentered = true;
  bool haveupload;
  final void Function()? store;
  CustomAppBar({
    super.key,
    required this.title,
    required this.height,
    required this.isSync,
    this.haveupload = false,
    required this.isCentered,
    this.store,
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
      title: Text(
        widget.title,
        maxLines: 2,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      backgroundColor: blue,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(2))),
      actions: [
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

showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Alert Dialog Title'),
        content: Text('This is the content of the alert dialog.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

import 'package:ev_pmis_app/provider/internet_provider.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../authentication/login_register.dart';
import 'connectivity_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
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
  Widget build(BuildContext context) {

    
    bool? status = false;
    var connectivityProvider = Provider.of<ConnectivityProvider>(context);
    print(status);
    return Consumer<ConnectivityProvider>(
      builder: (context, value, child) {
        bool isConnected = connectivityProvider.isConnected;

        return AppBar(
          centerTitle: isCentered ? true : false,
          title: Text(
            title,
            maxLines: 2,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          backgroundColor: blue,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(2))),
          actions: [
            Icon(
              isConnected ? Icons.wifi : Icons.signal_wifi_off,
              color: isConnected ? Colors.white : Colors.red,
            ),
           
            isSync
                ? InkWell(
                    onTap: () {
                      store!();
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
                : haveupload
                    ? Container(
                        padding: const EdgeInsets.all(5),
                        height: 30,
                        width: 130,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/material-excelpage');
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
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
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


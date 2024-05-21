import 'dart:io';
import 'package:ev_pmis_app/style.dart';
import 'package:flutter/material.dart';

class CustomAlertBox {
  Future<bool> customLogOut(BuildContext context, String title, String pushName,
      bool isExitingApp) async {
    bool a = false;
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12,),),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
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
                          a = true;
                          isExitingApp
                              ? exit(0)
                              : Navigator.pushNamedAndRemoveUntil(
                                  context, pushName, (route) => false);

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
            ),);
    return a;
  }
}

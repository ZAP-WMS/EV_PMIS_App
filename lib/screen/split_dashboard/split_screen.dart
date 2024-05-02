import 'dart:io';
import 'package:ev_pmis_app/style.dart';
import 'package:ev_pmis_app/widgets/custom_alert_box.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplitScreen extends StatelessWidget {
  final String? role;
  final String? userId;
  const SplitScreen({super.key, required this.role, this.userId});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        CustomAlertBox()
            .customLogOut(context, 'Do you want to Exit ?', '', true);
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(
            40,
          ),
          child: AppBar(
            backgroundColor: blue,
            centerTitle: true,
            title: const Text('Dashboard',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            actions: [
              Container(
                padding: const EdgeInsets.only(
                  right: 15,
                ),
                child: InkWell(
                  onTap: () {
                    onWillPop(context);
                  },
                  child: const Icon(
                    Icons.logout_sharp,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          height: height * 0.8,
          child: Column(
            children: [
              Expanded(
                  child: Container(
                margin: const EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/evDashboard',
                          arguments: {
                            "role": role,
                            "userId": userId,
                          },
                        );
                      },
                      child: Card(
                        elevation: 10,
                        child: Container(
                          height: height * 0.26,
                          width: context.width * 0.9,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage('assets/ev_dashboard.jpeg'),
                          )),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: context.width * 0.9,
                      height: 40,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(blue)),
                          onPressed: () {
                            Navigator.pushNamed(context, '/evDashboard',
                                arguments: {"role": role, "userId": userId});
                          },
                          child: const Text(
                            'EV Bus Project Analysis Dashboard',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          ),
                    )
                  ],
                ),
              )),
              Divider(
                color: blue,
                thickness: 2,
              ),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/demand',
                            arguments: {"role": role, "userId": userId});
                      },
                      child: Card(
                        elevation: 10,
                        child: Container(
                          height: height * 0.26,
                          width: context.width * 0.9,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage('assets/demand_energy.jpeg'),
                          )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: context.width * 0.9,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(blue)),
                          onPressed: () {
                            Navigator.pushNamed(context, '/demand',
                                arguments: {"role": role, "userId": userId});
                          },
                          child: const Text(
                            'EV Bus Depot Management System',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          )),
                    )
                  ],
                ),
              )),
            ],
          ),
        ),
        floatingActionButton: ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(blue)),
            onPressed: () {
              Navigator.pushNamed(context, '/cities-page',
                  arguments: {"userId": userId, "role": role});
            },
            child: const Text(
              'Proceed to cities',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),
            ),),
      ),
    );
  }

  Future<void> showCustomAlert(BuildContext pageContext) async {
    await showDialog(
        context: pageContext,
        builder: (context) {
          return Dialog(
            child: Container(
              width: 300,
              height: 150,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: const Icon(
                      Icons.warning,
                      color: Color.fromRGBO(243, 201, 75, 1),
                      size: 60,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: const Text(
                      'Are You Sure Want To Exit?',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 30,
                        margin: const EdgeInsets.all(5),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(blue)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'No',
                            style: TextStyle(fontSize: 15, color: white),
                          ),
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 30,
                        margin: const EdgeInsets.all(5),
                        child: ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.redAccent)),
                          onPressed: () {
                            exit(0);
                          },
                          child: const Text(
                            'Exit',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

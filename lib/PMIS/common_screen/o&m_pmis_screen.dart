import 'package:ev_pmis_app/style.dart';
import 'package:ev_pmis_app/PMIS/authentication/login_register.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class PmisAndOAndMScreen extends StatefulWidget {
  final String roleCentre;
  final String role;
  final String userId;

  const PmisAndOAndMScreen(
      {required this.role,
      required this.userId,
      required this.roleCentre,
      super.key});

  @override
  State<PmisAndOAndMScreen> createState() => _PmisAndOAndMScreenState();
}

class _PmisAndOAndMScreenState extends State<PmisAndOAndMScreen> {
  @override
  void initState() {
    ToastContext().init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/split_screen/background_logo.jpeg',
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 210,
                alignment: Alignment.center,
                //  decoration: BoxDecoration(color: splitscreenColor),
                child: Column(
                  children: [
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(seconds: 3),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Container(
                            height: 170,
                            width: 170,
                            child: Image.asset('assets/app_logo.png'),
                          ),
                        );
                      },
                    ),
                    Text('EV Monitoring', style: splitscreenStyle)
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              (widget.roleCentre == "PMIS" ||
                      widget.role == "admin" ||
                      widget.role == "projectManager")
                  ? InkWell(
                      onTap: () {
                        if (widget.role == "projectManager" &&
                            widget.roleCentre != "PMIS") {
                          Toast.show(
                            "PMIS is availabe in view mode only for this user",
                            duration: Toast.lengthLong,
                            backgroundColor: blue,
                            gravity: Toast.bottom,
                            textStyle: TextStyle(
                              color: white,
                            ),
                          );
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/splitDashboard',
                                arguments: {
                                  "roleCentre": "PMIS",
                                  'userId': widget.userId,
                                  "role": widget.role
                                },
                                (route) => false,
                              );
                            },
                          );
                        } else {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/splitDashboard',
                            arguments: {
                              "roleCentre": "PMIS",
                              'userId': widget.userId,
                              "role": widget.role
                            },
                            (route) => false,
                          );
                        }
                      },
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(seconds: 2),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset(
                                'assets/split_screen/pmis_new.png',
                                height: 160,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : InkWell(
                      onTap: () async {
                        Toast.show(
                          "Please Select O&M and Proceed",
                          duration: Toast.lengthLong,
                          backgroundColor: blue,
                          gravity: Toast.bottom,
                          textStyle: TextStyle(
                            color: white,
                          ),
                        );
                      },
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(seconds: 1),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset(
                                'assets/split_screen/pmis_new.png',
                                height: 160,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              (widget.roleCentre == "O&M" ||
                      widget.role == "admin" ||
                      widget.role == "projectManager")
                  ? InkWell(
                      onTap: () {
                        if (widget.role == "projectManager" &&
                            widget.roleCentre != "O&M") {
                          Toast.show(
                            "O&M is availabe in view mode only for this user",
                            duration: Toast.lengthLong,
                            backgroundColor: blue,
                            gravity: Toast.bottom,
                            textStyle: TextStyle(
                              color: white,
                            ),
                          );
                          Future.delayed(
                            const Duration(  
                              seconds: 2,
                            ),
                            () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/cities-page',
                                arguments: {
                                  // "roleCentre": roleCentre,
                                  'userId': widget.userId,
                                  "role": widget.role,
                                  "roleCentre": "O&M"
                                },
                                (route) => false,
                              );
                            },
                          );
                        } else {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/cities-page',
                            arguments: {
                              // "roleCentre": roleCentre,
                              'userId': widget.userId,
                              "role": widget.role,
                              "roleCentre": "O&M"
                            },
                            (route) => false,
                          );
                        }
                      },
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(seconds: 1),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Image.asset(
                                'assets/split_screen/o&m_new.png',
                                height: 130,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        Toast.show(
                          "Please Select PMIS and Proceed",
                          duration: Toast.lengthLong,
                          backgroundColor: blue,
                          gravity: Toast.bottom,
                          textStyle: TextStyle(
                            color: white,
                          ),
                        );
                      },
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(seconds: 3),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Image.asset(
                                'assets/split_screen/o&m_new.png',
                                height: 130,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

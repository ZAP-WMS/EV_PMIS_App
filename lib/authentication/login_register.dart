import 'package:ev_pmis_app/authentication/login_page.dart';
import 'package:ev_pmis_app/authentication/register_page.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(280),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(children: [
                    Text("PMIS", style: headlineBold),
                    _space(10),
                    Text(" EV Monitoring ", style: headlineBold),
                    _space(5),
                    Text("Login to access your account below!",
                        style: headline),
                    //    _space(10),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            'assets/Green.jpeg',
                            height: 70,
                            width: 70,
                          ),
                          Image.asset(
                            'assets/sustainable.jpeg',
                            height: 70,
                            width: 70,
                          ),
                        ],
                      ),
                    ),
                    _space(20),
                    TabBar(
                      labelColor: blue,
                      // labelStyle: buttonWhite,
                      unselectedLabelColor: Colors.black,

                      //indicatorSize: TabBarIndicatorSize.label,
                      indicator: MaterialIndicator(
                        horizontalPadding: 24,
                        bottomLeftRadius: 8,
                        bottomRightRadius: 8,
                        color: blue,
                        paintingStyle: PaintingStyle.fill,
                      ),

                      tabs: const [
                        Tab(
                          text: "Sign In",
                        ),
                        Tab(
                          text: "Register",
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
              body: TabBarView(children: [
                const LoginPage(),
                RegisterPge(),
              ]),
            )),
      ),
    );
  }

  Widget _space(double i) {
    return SizedBox(
      height: i,
    );
  }
}

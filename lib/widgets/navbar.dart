import 'package:ev_pmis_app/authentication/login_register.dart';
import 'package:ev_pmis_app/feedback/chat.dart';
import 'package:ev_pmis_app/screen/citiespage/cities_home.dart';
import 'package:ev_pmis_app/screen/safetyreport/safetyfield.dart';
import 'package:ev_pmis_app/widgets/internet_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screen/homepage/gallery.dart';
import '../style.dart';

class NavbarDrawer extends StatefulWidget {
  const NavbarDrawer({super.key});

  @override
  State<NavbarDrawer> createState() => _NavbarDrawerState();
}

class _NavbarDrawerState extends State<NavbarDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: blue),
            currentAccountPicture: const Icon(
              Icons.face,
              size: 48.0,
              color: Colors.white,
            ),
            // otherAccountsPictures: const [
            //   Icon(
            //     Icons.bookmark_border,
            //     color: Colors.white,
            //   ),
            // ],
            accountName: Text(
              userId!,
              textAlign: TextAlign.center,
            ),
            accountEmail: const Text(''),
          ),
          ListTile(
              leading: Icon(
                Icons.home,
                color: blue,
              ),
              title: const Text(
                'Home',
              ),
              onTap: () {
                // SystemChrome.setPreferredOrientations([
                //   DeviceOrientation.portraitUp,
                //   DeviceOrientation.portraitDown,
                //   // DeviceOrientation.landscapeLeft,
                // ]);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CitiesHome(),
                  ),
                );
              }),
          // ListTile(
          //     leading: const Icon(Icons.mood),
          //     title: const Text('Mood'),
          //     onTap: () {
          //       // SystemChrome.setPreferredOrientations([
          //       //   DeviceOrientation.portraitUp,
          //       //   DeviceOrientation.portraitDown,
          //       //   // DeviceOrientation.landscapeLeft,
          //       // ]);
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (_) => const CitiesHome(),
          //         ),
          //       );
          //     }),
          ListTile(
              leading: Icon(
                Icons.note_add,
                color: blue,
              ),
              title: const Text('Chat'),
              onTap: () {
                // SystemChrome.setPreferredOrientations([
                //   DeviceOrientation.portraitUp,
                //   DeviceOrientation.portraitDown,
                //   // DeviceOrientation.landscapeLeft,
                // ]);
                Navigator.pushReplacementNamed(context, '/chatpage');
              }),
          const Divider(),
          // ListTile(
          //     leading: const Icon(Icons.settings),
          //     title: const Text('Settings'),
          //     onTap: () {
          //       // SystemChrome.setPreferredOrientations([
          //       //   DeviceOrientation.portraitUp,
          //       //   DeviceOrientation.portraitDown,
          //       //   // DeviceOrientation.landscapeLeft,
          //       // ]);
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (_) => CitiesHome(),
          //         ),
          //       );
          //     }),
          // const Divider(),
          ListTile(
              leading: Icon(
                Icons.logout_rounded,
                color: blue,
              ),
              title: const Text('Logout'),
              onTap: () {
                // SystemChrome.setPreferredOrientations([
                //   DeviceOrientation.portraitUp,
                //   DeviceOrientation.portraitDown,
                //   // DeviceOrientation.landscapeLeft,
                // ]);
                onWillPop(context);
              }),
        ],
      ),
    );
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
                          onTap: () async {
                            a = true;
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            await preferences.clear();
                            // ignore: use_build_context_synchronously
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginRegister(),
                                ),
                                (route) => false);

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
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/views/authentication/authservice.dart';
import 'package:ev_pmis_app/views/dailyreport/notification_userlist.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../style.dart';
import '../views/authentication/login_register.dart';
import '../views/citiespage/cities_home.dart';

class NavbarDrawer extends StatefulWidget {
  String? role;
  NavbarDrawer({
    required this.role,
    super.key,
  });

  @override
  State<NavbarDrawer> createState() => _NavbarDrawerState();
}

class _NavbarDrawerState extends State<NavbarDrawer> {
  String userId = '';
  bool isProjectManager = false;
  String? role;
  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    getUserId();
    initializeData();
    super.initState();
  }

  Future<void> initializeData() async {
    await verifyProjectManager();

    setState(() {
      // Update UI after verifying project manager status
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.5;
    return Drawer(
      width: width,
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
            accountName: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                userId,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
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
                    builder: (_) => CitiesHome(),
                  ),
                );
              }),
          widget.role == 'projectManager'
              ? ListTile(
                  leading: Icon(
                    Icons.notification_important,
                    color: blue,
                  ),
                  title: const Text(
                    'Notifications',
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => userList(),
                      ),
                    );
                  })
              : Container(),
          ListTile(
              leading: Icon(
                Icons.note_add,
                color: blue,
              ),
              title: const Text('Chat'),
              onTap: () {
                Navigator.pushNamed(context, '/chat-page');
              }),
          ListTile(
              leading: Icon(
                Icons.logout_rounded,
                color: blue,
              ),
              title: const Text('Logout'),
              onTap: () {
                onWillPop(context);
              }),
        ],
      ),
    );
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
      print('UserId - $value');
      setState(() {});
    });
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
              content: Column(
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
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          await preferences.remove('role');
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginRegister(),
                              ),
                              (Route<dynamic> route) => false);

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
            ));
    return a;
  }

  Future<void> verifyProjectManager() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('AssignedRole')
        .where('roles', arrayContains: 'Project Manager')
        .get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.data()).toList();

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i]['userId'].toString() == userId.toString()) {
        isProjectManager = true;
        setState(() {});
      }
    }
  }
}

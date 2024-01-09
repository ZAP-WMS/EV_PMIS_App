import 'dart:io';
import 'package:ev_pmis_app/style.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../authentication/authservice.dart';
import '../../shared_preferences/shared_preferences.dart';
import '../../widgets/navbar.dart';

dynamic userId = '';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  String role = '';
  List<String> updates = [
    'Fixed Bugs',
    'Added cache features',
    'Admin role available completely',
    'Improved overall performance',
    'User now get a pop-up of user id and password on register',
    'User can download uploaded files',
    'Internet connectivity checker added',
  ];

  @override
  void initState() {
    isNewVersion();
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 2;
    List imglist = [
      'assets/gallery/Picture1.png',
      'assets/gallery/Picture2.png',
      'assets/gallery/Picture3.png',
      'assets/gallery/Picture4.png',
      'assets/gallery/Picture5.png',
      'assets/gallery/Picture1.png',
      'assets/gallery/Picture2.png',
    ];
    return Scaffold(
      drawer: const NavbarDrawer(),
      appBar: CustomAppBar(
        isCentered: true,
        title: 'Gallery',
        height: 55,
        isSync: false,
      ),
      body: WillPopScope(
        onWillPop: () {
          return onWillPopCloseApp(context);
        },
        child: Stack(
          children: [
            GridView.count(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.89,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: List.generate(imglist.length, (index) {
                return Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Card(
                      elevation: 25,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      shadowColor: blue,
                      child: Image.asset(
                        imglist[index],
                        fit: BoxFit.fill,
                      ),
                    ));
              }),
            ),
            Positioned(
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    height: 48,
                    width: MediaQuery.of(context).size.width - 20,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          // minimumSize: MediaQuery.of(context).size,
                          backgroundColor: blue,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/homepage',
                              arguments: role);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Procceed',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: white,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(
                              width: 20,
                            ),
                            const Icon(
                              Icons.forward,
                              size: 35,
                            )
                          ],
                        )),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
      setState(() {});
    });
  }

  void getData() async {
    role = await StoredDataPreferences.getSharedPreferences('role');
  }

  void isNewVersion() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final getVersion = preferences.getString('isNewVersion');

    if (getVersion != '1.01') {
      preferences.setString('isNewVersion', '1.01');
      await showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: white,
              child: Container(
                height: 500,
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Divider(
                      height: 1,
                      color: black,
                      thickness: 1,
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 5, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            'What\'s New : v1.01',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      color: Colors.black,
                      thickness: 1,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: updates.length,
                        itemBuilder: (context, index) {
                          return Container(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 10, top: 10, bottom: 10),
                              child: RichText(
                                  text: TextSpan(children: [
                                WidgetSpan(
                                    child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Icon(
                                    Icons.star,
                                    size: 12,
                                    color: black,
                                  ),
                                )),
                                TextSpan(
                                  text: '${updates[index]}',
                                  style: TextStyle(fontSize: 16, color: black),
                                )
                              ])));
                        }),
                  ],
                ),
              ),
            );
          });
    }
  }
}

Future<bool> onWillPopCloseApp(BuildContext context) async {
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
                          exit(0);
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

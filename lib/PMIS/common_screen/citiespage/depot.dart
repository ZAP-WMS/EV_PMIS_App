import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/components/Loading_page.dart';
import 'package:ev_pmis_app/PMIS/provider/cities_provider.dart';
import 'package:ev_pmis_app/PMIS/authentication/authservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../style.dart';

String userId = '';

class DepotPage extends StatefulWidget {
  final String? role;
  String? cityName;
  final String? userId;
  final String? roleCentre;
  DepotPage(
      {super.key, this.cityName, this.role, this.userId, this.roleCentre});

  @override
  State<DepotPage> createState() => _DepotPageState();
}

class _DepotPageState extends State<DepotPage> {
  Stream? _stream;

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<CitiesProvider>(
        builder: (context, value, child) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('DepoName')
                  .doc(value.getName)
                  .collection('AllDepots')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LoadingPage());
                }
                return Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        itemCount: snapshot.data!.docs.length,
                        padding: const EdgeInsets.only(bottom: 15, top: 10),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.9,
                                mainAxisSpacing: 2,
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                widget.cityName = Provider.of<CitiesProvider>(
                                        context,
                                        listen: false,
                                        )
                                    .getName;
                                Navigator.pushNamed(context, '/overview page',
                                    arguments: {
                                      'depoName': snapshot.data!.docs[index]
                                          ['DepoName'],
                                      'role': widget.role,
                                      'userId': userId,
                                      "roleCentre": widget.roleCentre,
                                      "cityName": widget.cityName
                                    });
                              },
                              child: cards(
                                snapshot.data!.docs[index]['DepoName'],
                                snapshot.data!.docs[index]['DepoUrl'],
                              )
                              );
                        },
                      ),
                    ),
                  ],
                );
              });
        },
      ),
    );
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
      print('UserId - $value');
      // setState(() {});
    });
  }

  Widget cards(String desc, String image) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      decoration: BoxDecoration(
          color: grey,
          border: Border.all(color: blue, width: 2),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            minRadius: 40,
            maxRadius: 40,
            backgroundColor: grey,
            child: SizedBox(
              height: 60,
              width: 60,
              child: Container(
                  decoration: BoxDecoration(
                      // border: Border.all(color: blue),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            image,
                          ),
                          //  NetworkImage(image),
                          fit: BoxFit.cover))),
              // child: Image.asset(
              //   image,
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
          // const SizedBox(height: 5),
          Container(
            // margin: const EdgeInsets.all(1),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 110),
              child: Text(
                desc,
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget depolist(String image, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width * 90,
          height: MediaQuery.of(context).size.width * 90,
          decoration: BoxDecoration(
            border: Border.all(color: grey),
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                image,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: blue, fontWeight: FontWeight.bold, fontSize: 11),
          ),
        ),
      ],
    );
  }

  // void getToken() async {
  //   String? token = await NotificationService().getFCMToken();
  //   // Now you can use the token variable here
  //   NotificationService().saveTokenToFirestore(userId, token);

  //   print('FCM Token: $token');
  // }
}
